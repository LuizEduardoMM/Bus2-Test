// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../home/data/datasources/home_page_datasource.dart' as _i1025;
import '../../home/data/repositories/home_page_repository_impl.dart' as _i123;
import '../../home/domain/repositories/home_page_repository.dart' as _i676;
import '../../home/domain/use_cases/fetch_user_usecase.dart' as _i232;
import '../../home/domain/use_cases/search_user_usecase.dart' as _i624;
import '../../home/presentation/cubit/home_page_cubit.dart' as _i328;
import '../data/repositories/favorites_repository_impl.dart' as _i243;
import '../data/services/prefences_service.dart' as _i852;
import '../data/services/shared_preferences_service.dart' as _i375;
import '../domain/repositores/favorites_repository.dart' as _i90;
import '../domain/use_cases/add_favorites_usecase.dart' as _i86;
import '../domain/use_cases/get_favorites_usecase.dart' as _i1044;
import '../domain/use_cases/remove_favorites_usecase.dart' as _i382;
import '../domain/use_cases/search_favorites_usecase.dart' as _i611;
import '../presentation/cubit/favorites_cubit.dart' as _i317;
import 'register_module.dart' as _i291;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.factory<_i611.SearchFavoritesUseCase>(
    () => _i611.SearchFavoritesUseCase(),
  );
  gh.factory<_i624.SearchHomeUseCase>(() => _i624.SearchHomeUseCase());
  gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
  gh.singleton<_i1025.HomePageDatasource>(
    () => _i1025.HomePageDatasourceImpl(gh<_i361.Dio>()),
  );
  gh.singleton<_i852.PreferencesService>(
    () => _i375.SharedPreferencesService(),
  );
  gh.singleton<_i676.HomePageRepository>(
    () => _i123.HomePageRepositoryImpl(gh<_i1025.HomePageDatasource>()),
  );
  gh.singleton<_i90.FavoritesRepository>(
    () => _i243.FavoritesRepositoryImpl(gh<_i852.PreferencesService>()),
  );
  gh.factory<_i232.FetchNewUserUseCase>(
    () => _i232.FetchNewUserUseCase(gh<_i676.HomePageRepository>()),
  );
  gh.factory<_i86.AddFavoritesUseCase>(
    () => _i86.AddFavoritesUseCase(gh<_i90.FavoritesRepository>()),
  );
  gh.factory<_i1044.GetFavoritesUseCase>(
    () => _i1044.GetFavoritesUseCase(gh<_i90.FavoritesRepository>()),
  );
  gh.factory<_i382.RemoveFavoritesUseCase>(
    () => _i382.RemoveFavoritesUseCase(gh<_i90.FavoritesRepository>()),
  );
  gh.singleton<_i317.FavoritesCubit>(
    () => _i317.FavoritesCubit(
      gh<_i86.AddFavoritesUseCase>(),
      gh<_i1044.GetFavoritesUseCase>(),
      gh<_i382.RemoveFavoritesUseCase>(),
      gh<_i611.SearchFavoritesUseCase>(),
    ),
  );
  gh.singleton<_i328.HomePageCubit>(
    () => _i328.HomePageCubit(
      gh<_i232.FetchNewUserUseCase>(),
      gh<_i624.SearchHomeUseCase>(),
    ),
  );
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
