import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/cubit/favorites_cubit.dart';
import '../../../details/presentation/pages/details_page.dart';

class PersistedUsersPage extends StatefulWidget {
  const PersistedUsersPage({super.key});

  @override
  State<PersistedUsersPage> createState() => _PersistedUsersPageState();
}

class _PersistedUsersPageState extends State<PersistedUsersPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários Salvos')),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoritesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<FavoritesCubit>().loadFavorites();
                      },
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is FavoritesSuccess) {
            if (state.favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('Nenhum usuário favoritado', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Comece a adicionar favoritos na tela principal',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final user = state.favorites[index];

                return Dismissible(
                  key: ValueKey(user.uuid),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    context.read<FavoritesCubit>().removeFavorite(user.uuid);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${user.firstName} removido dos favoritos'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(user.pictureLarge)),
                      title: Text(user.firstName),
                      subtitle: Text('${user.email}\n${user.city}, ${user.state}'),
                      isThreeLine: true,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<FavoritesCubit>(),
                              child: DetailsPage(user: user),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Estado desconhecido.'));
        },
      ),
    );
  }
}
