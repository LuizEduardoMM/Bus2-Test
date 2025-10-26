import 'package:bus2_test/modules/home/data/datasources/home_page_datasource.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/entities/user.dart';
import '../../domain/repositories/home_page_repository.dart';

@Singleton(as: HomePageRepository)
class HomePageRepositoryImpl implements HomePageRepository {
  final HomePageDatasource _datasource;
  HomePageRepositoryImpl(this._datasource);
  @override
  Future<User> fetchNewUser() {
    return _datasource.fetchNewUser();
  }
}
