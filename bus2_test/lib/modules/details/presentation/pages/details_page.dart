import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/entities/user.dart';
import '../../../core/presentation/cubit/favorites_cubit.dart';
import '../widgets/info_row.dart';
import '../widgets/info_section.dart';

class DetailsPage extends StatelessWidget {
  final User user;

  const DetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              bool isFav = false;

              if (state is FavoritesSuccess) {
                isFav = state.favorites.any((u) => u.uuid == user.uuid);
              }

              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                color: isFav ? Colors.red : Colors.grey,
                onPressed: () {
                  if (isFav) {
                    context.read<FavoritesCubit>().removeFavorite(user.uuid);
                  } else {
                    context.read<FavoritesCubit>().addFavorite(user);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(radius: 60, backgroundImage: NetworkImage(user.pictureLarge)),
            const SizedBox(height: 24),
            Text(
              '${user.firstName} ${user.lastName}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${user.gender.toUpperCase()} • ${user.age} anos',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            InfoSection(
              title: 'Contato',
              children: [
                InfoRow(label: 'Email:', value: user.email),
                InfoRow(label: 'Telefone:', value: user.phone),
                InfoRow(label: 'Usuário:', value: user.username),
              ],
            ),
            const SizedBox(height: 16),
            InfoSection(
              title: 'Localização',
              children: [
                InfoRow(label: 'Rua:', value: '${user.street}, nº ${user.streetNumber}'),
                InfoRow(label: 'Cidade:', value: user.city),
                InfoRow(label: 'Estado:', value: user.state),
                InfoRow(label: 'País:', value: user.country),
                InfoRow(label: 'Nacionalidade:', value: user.nationality),
              ],
            ),
            const SizedBox(height: 16),
            InfoSection(
              title: 'Identificação',
              children: [InfoRow(label: 'UUID:', value: user.uuid)],
            ),
          ],
        ),
      ),
    );
  }
}
