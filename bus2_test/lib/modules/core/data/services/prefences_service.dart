import '../../domain/entities/user.dart';

abstract class PreferencesService {
  Future<void> saveFavorite(User user);
  Future<void> removeFavorite(String userId);
  Future<List<User>> getFavorites();
}
