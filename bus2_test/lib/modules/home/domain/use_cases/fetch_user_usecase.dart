import 'package:bus2_test/modules/home/domain/repositories/home_page_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/entities/user.dart';

@injectable
class FetchNewUserUseCase {
  final HomePageRepository _repository;

  FetchNewUserUseCase(this._repository);

  Future<User> call() async {
    return _repository.fetchNewUser();
  }
}
