import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/entities/user.dart';
import '../../../core/presentation/cubit/favorites_cubit.dart';
import '../../../core/presentation/theme/app_colors.dart';
import '../../../core/presentation/theme/app_sizes.dart';
import '../../../core/presentation/theme/app_text_styles.dart';
import '../../../core/presentation/widgets/search_field.dart';
import '../../../details/presentation/pages/details_page.dart';
import '../widgets/favorite_user_tile.dart';

class PersistedUsersPage extends StatefulWidget {
  const PersistedUsersPage({super.key});

  @override
  State<PersistedUsersPage> createState() => _PersistedUsersPageState();
}

class _PersistedUsersPageState extends State<PersistedUsersPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text('Favoritos'),
              backgroundColor: AppColors.backgroundLight,
              surfaceTintColor: Colors.transparent,
              elevation: innerBoxIsScrolled ? 4.0 : 0.0,
              forceElevated: innerBoxIsScrolled,
              pinned: true,
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(72.0),
                child: SearchField(
                  controller: _searchController,
                  onChanged: (query) {
                    context.read<FavoritesCubit>().searchFavorites(query);
                  },
                  hintText: 'Buscar nos favoritos...',
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
          top: false,
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is FavoritesError) {
                return _buildError(context, state.message);
              }

              if (state is FavoritesSuccess) {
                if (state.allFavorites.isEmpty) {
                  return _buildEmpty(context);
                }

                if (state.filteredFavorites.isEmpty) {
                  return _buildNoResults(context);
                }

                return ListView.builder(
                  padding: pagePadding,
                  itemCount: state.filteredFavorites.length,
                  itemBuilder: (context, index) {
                    final user = state.filteredFavorites[index];
                    final heroTag = 'favorite_${user.uuid}';
                    return FavoriteProfileTile(
                      user: user,
                      heroTag: heroTag,
                      onTap: () => _navigateToDetails(context, user, heroTag),
                      onRemove: () => _removeFavorite(context, user),
                    );
                  },
                );
              }

              return const Center(child: Text('Estado desconhecido'));
            },
          ),
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
              onPressed: () => context.read<FavoritesCubit>().loadFavorites(),
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
            const Icon(Icons.favorite_border, size: 64, color: AppColors.textLabel),
            gapH16,
            Text('Nenhum favorito ainda', style: AppTextStyles.getSectionTitle(textTheme)),
            gapH8,
            Text(
              'Adicione usuários favoritos na tela principal',
              style: AppTextStyles.getInfoLabelStyle(textTheme),
              textAlign: TextAlign.center,
            ),
          ],
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

  void _navigateToDetails(BuildContext context, User user, String heroTag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<FavoritesCubit>(),
          child: DetailsPage(user: user, heroTag: heroTag),
        ),
      ),
    );
  }

  void _removeFavorite(BuildContext context, User user) {
    context.read<FavoritesCubit>().removeFavorite(user.uuid);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user.firstName} removido dos favoritos'),
        backgroundColor: AppColors.textHeadline,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: br8),
        margin: pagePadding,
        action: SnackBarAction(
          label: 'DESFAZER',
          textColor: AppColors.primary,
          onPressed: () {
            context.read<FavoritesCubit>().addFavorite(user);
          },
        ),
      ),
    );
  }
}
