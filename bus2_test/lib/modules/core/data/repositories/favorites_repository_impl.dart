import 'package:injectable/injectable.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositores/favorites_repository.dart';
import '../services/prefences_service.dart';

@Singleton(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  final PreferencesService preferencesService;

  FavoritesRepositoryImpl(this.preferencesService);

  @override
  Future<void> addFavorite(User user) {
    return preferencesService.saveFavorite(user);
  }

  @override
  Future<List<User>> getFavorites() {
    return preferencesService.getFavorites();
  }

  @override
  Future<void> removeFavorite(String userId) {
    return preferencesService.removeFavorite(userId);
  }
}
