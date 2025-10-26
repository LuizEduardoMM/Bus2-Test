import '../../../core/domain/entities/user.dart';

abstract class HomePageRepository {
  Future<User> fetchNewUser();
}
