import 'package:bus2_test/modules/core/domain/repositores/favorites_repository.dart';
import 'package:injectable/injectable.dart';

import '../entities/user.dart';

@injectable
class GetFavoritesUseCase {
  final FavoritesRepository _repository;

  GetFavoritesUseCase(this._repository);

  Future<List<User>> call() async {
    final users = await _repository.getFavorites();
    return users;
  }
}
