import 'package:bus2_test/modules/core/domain/repositores/favorites_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveFavoritesUseCase {
  final FavoritesRepository _repository;

  RemoveFavoritesUseCase(this._repository);

  Future<void> call(String userId) async {
    await _repository.removeFavorite(userId);
    return;
  }
}
