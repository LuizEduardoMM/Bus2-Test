import 'package:bus2_test/modules/core/domain/use_cases/add_favorites_usecase.dart';
import 'package:bus2_test/modules/core/domain/use_cases/get_favorites_usecase.dart';
import 'package:bus2_test/modules/core/domain/use_cases/remove_favorites_usecase.dart';
import 'package:bus2_test/modules/core/domain/use_cases/search_favorites_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/entities/user.dart';

part 'favorites_state.dart';

@singleton
class FavoritesCubit extends Cubit<FavoritesState> {
  final AddFavoritesUseCase _addFavoritesUseCase;
  final GetFavoritesUseCase _getFavoritesUseCase;
  final RemoveFavoritesUseCase _removeFavoritesUseCase;
  final SearchFavoritesUseCase _searchFavoritesUseCase;

  FavoritesCubit(
    this._addFavoritesUseCase,
    this._getFavoritesUseCase,
    this._removeFavoritesUseCase,
    this._searchFavoritesUseCase,
  ) : super(FavoritesInitial());

  Future<void> addFavorite(User user) async {
    final currentState = state as FavoritesSuccess;
    final newList = List<User>.from(currentState.allFavorites)..add(user);
    newList.sort((a, b) => a.firstName.compareTo(b.firstName));

    emit(FavoritesSuccess(allFavorites: newList, filteredFavorites: newList));

    try {
      await _addFavoritesUseCase(user);
    } catch (e) {
      emit(FavoritesError("Failed to add favorite: $e"));
      emit(currentState);
    }
  }

  Future<void> removeFavorite(String userId) async {
    final currentState = state as FavoritesSuccess;
    final newList = List<User>.from(currentState.allFavorites)..removeWhere((u) => u.uuid == userId);

    emit(FavoritesSuccess(allFavorites: newList, filteredFavorites: newList));

    try {
      await _removeFavoritesUseCase(userId);
    } catch (e) {
      emit(FavoritesError("Failed to remove favorite: $e"));
      emit(currentState);
    }
  }

  Future<void> loadFavorites() async {
    try {
      final favorites = await _getFavoritesUseCase();
      favorites.sort((a, b) => a.firstName.compareTo(b.firstName));

      emit(FavoritesSuccess(allFavorites: favorites, filteredFavorites: favorites));
    } catch (e) {
      emit(FavoritesError("Failed to load favorites: $e"));
    }
  }

  void searchFavorites(String query) {
    if (state is! FavoritesSuccess) return;

    final currentState = state as FavoritesSuccess;

    final filteredList = _searchFavoritesUseCase(
      SearchFavoritesParams(favorites: currentState.allFavorites, query: query),
    );

    emit(currentState.copyWith(filteredFavorites: filteredList));
  }
}
