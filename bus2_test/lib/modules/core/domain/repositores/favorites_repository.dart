import '../entities/user.dart';

abstract class FavoritesRepository {
  Future<void> addFavorite(User user);
  Future<void> removeFavorite(String userId);
  Future<List<User>> getFavorites();
}
