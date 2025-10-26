import 'package:bloc/bloc.dart';
import 'package:bus2_test/modules/core/domain/use_cases/add_favorites_usecase.dart';
import 'package:bus2_test/modules/core/domain/use_cases/get_favorites_usecase.dart';
import 'package:bus2_test/modules/core/domain/use_cases/remove_favorites_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/entities/user.dart';

part 'favorites_state.dart';

@singleton
class FavoritesCubit extends Cubit<FavoritesState> {
  final AddFavoritesUseCase _addFavoritesUseCase;
  final GetFavoritesUseCase _getFavoritesUseCase;
  final RemoveFavoritesUseCase _removeFavoritesUseCase;

  FavoritesCubit(this._addFavoritesUseCase, this._getFavoritesUseCase, this._removeFavoritesUseCase)
    : super(FavoritesInitial());

  Future<void> addFavorite(User user) async {
    try {
      await _addFavoritesUseCase(user);
      await loadFavorites();
    } catch (e) {
      emit(FavoritesError("Failed to add favorite: $e"));
    }
  }

  Future<void> removeFavorite(String userId) async {
    try {
      await _removeFavoritesUseCase(userId);
      await loadFavorites();
    } catch (e) {
      emit(FavoritesError("Failed to remove favorite: $e"));
    }
  }

  Future<void> loadFavorites() async {
    try {
      final favorites = await _getFavoritesUseCase();
      emit(FavoritesSuccess(favorites));
    } catch (e) {
      emit(FavoritesError("Failed to load favorites: $e"));
    }
  }
}
