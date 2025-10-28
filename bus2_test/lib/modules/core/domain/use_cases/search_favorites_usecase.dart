import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../entities/user.dart';

@injectable
class SearchFavoritesUseCase {
  List<User> call(SearchFavoritesParams params) {
    final favorites = params.favorites;
    final query = params.query.toLowerCase();

    if (query.isEmpty) {
      return favorites;
    }

    return favorites.where((user) {
      final name = '${user.firstName} ${user.lastName}'.toLowerCase();
      final email = user.email.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();
  }
}

class SearchFavoritesParams extends Equatable {
  final List<User> favorites;
  final String query;

  const SearchFavoritesParams({required this.favorites, required this.query});

  @override
  List<Object?> get props => [favorites, query];
}
