import 'package:bus2_test/modules/core/injection/injection.dart';
import 'package:bus2_test/modules/core/presentation/cubit/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/theme/app_colors.dart';
import '../../../core/presentation/theme/app_sizes.dart';
import '../../../core/presentation/theme/app_text_styles.dart';
import '../../../core/presentation/widgets/search_field.dart';
import '../../../details/presentation/pages/details_page.dart';
import '../../../persisted_user/presentation/pages/persited_user_page.dart';
import '../cubit/home_page_cubit.dart';
import '../widgets/user_list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _homePageCubit = getIt<HomePageCubit>();
  bool _wasVisible = true;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        _hasInitialized = true;
        _homePageCubit.startFetchingUsers(this);
      }
    });
    _searchController.addListener(() {
      _homePageCubit.searchUsers(_searchController.text, this);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final isCurrentRoute = ModalRoute.of(context)?.isCurrent ?? false;

    if (!_wasVisible && isCurrentRoute) {
      _searchController.clear();
      _homePageCubit.resetSearch(this);
      FocusManager.instance.primaryFocus?.unfocus();
    }

    _wasVisible = isCurrentRoute;
  }

  @override
  void dispose() {
    _homePageCubit.stopFetchingUsers();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text('Random Users'),
              backgroundColor: AppColors.backgroundLight,
              surfaceTintColor: Colors.transparent,
              elevation: innerBoxIsScrolled ? 4.0 : 0.0,
              forceElevated: innerBoxIsScrolled,
              pinned: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.storage_rounded),
                  tooltip: 'Usuários Salvos',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PersistedUsersPage()));
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(72.0),
                child: SearchField(
                  controller: _searchController,
                  onChanged: (query) {
                    _homePageCubit.searchUsers(query, this);
                  },
                  hintText: 'Buscar usuários...',
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
          top: false,
          child: BlocBuilder<HomePageCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is HomeError) {
                return _buildError(context, state.message);
              }

              if (state is HomeSuccess) {
                if (state.allUsers.isEmpty && state is! HomeLoading) {
                  return _buildEmpty(context);
                }

                if (state.filteredUsers.isEmpty && state.allUsers.isNotEmpty) {
                  return _buildNoResults(context);
                }

                return ListView.builder(
                  padding: pagePadding,
                  itemCount: state.filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = state.filteredUsers[index];

                    return UserListTile(
                      user: user,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: getIt<FavoritesCubit>(),
                              child: DetailsPage(user: user, heroTag: user.uuid),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }

              return const Center(child: Text('Estado desconhecido.'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNoResults(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: AppColors.textLabel),
            gapH16,
            Text('Nenhum resultado', style: AppTextStyles.getSectionTitle(textTheme)),
            gapH8,
            Text(
              'Não encontramos usuários com "${_searchController.text}"',
              style: AppTextStyles.getInfoLabelStyle(textTheme),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.favorite, size: 64),
            gapH16,
            Text('Ocorreu um Erro', style: AppTextStyles.getSectionTitle(textTheme), textAlign: TextAlign.center),
            gapH8,
            Text(message, style: AppTextStyles.getInfoLabelStyle(textTheme), textAlign: TextAlign.center),
            gapH24,
            FilledButton(
              onPressed: () => _homePageCubit.startFetchingUsers(this),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 64, color: AppColors.textLabel),
            gapH16,
            Text('Nenhum usuário', style: AppTextStyles.getSectionTitle(textTheme)),
            gapH8,
            Text(
              'Aguardando a busca por novos usuários...',
              style: AppTextStyles.getInfoLabelStyle(textTheme),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
