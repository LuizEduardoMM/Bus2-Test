import 'package:bus2_test/modules/core/injection/injection.dart';
import 'package:bus2_test/modules/core/presentation/cubit/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../details/presentation/pages/details_page.dart';
import '../../../persisted_user/presentation/pages/persited_user_page.dart';
import '../cubit/home_page_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomePageCubit>().startFetchingUsers(this);
    });
  }

  @override
  void dispose() {
    context.read<HomePageCubit>().stopFetchingUsers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<HomePageCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Random Users'),
          actions: [
            IconButton(
              icon: const Icon(Icons.storage_rounded),
              tooltip: 'Usuários Salvos',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        BlocProvider.value(value: getIt<FavoritesCubit>(), child: const PersistedUsersPage()),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<HomePageCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial || state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (state is HomeSuccess) {
              if (state.users.isEmpty) {
                return const Center(child: Text('Nenhum usuário encontrado.'));
              }

              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];

                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(user.pictureLarge)),
                    title: Text(user.firstName),
                    subtitle: Text('${user.email}\n${user.city}, ${user.state}'),

                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: getIt<FavoritesCubit>(),
                            child: DetailsPage(user: user),
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
    );
  }
}
