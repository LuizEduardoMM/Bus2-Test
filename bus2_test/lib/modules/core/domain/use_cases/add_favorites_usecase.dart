import 'package:bus2_test/modules/core/domain/repositores/favorites_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/entities/user.dart';

@injectable
class AddFavoritesUseCase {
  final FavoritesRepository _repository;

  AddFavoritesUseCase(this._repository);

  Future<void> call(User user) async {
    await _repository.addFavorite(user);
    return;
  }
}
