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

  String _currentQuery = '';
  bool _isLoaded = false;

  FavoritesCubit(
    this._addFavoritesUseCase,
    this._getFavoritesUseCase,
    this._removeFavoritesUseCase,
    this._searchFavoritesUseCase,
  ) : super(FavoritesInitial());

  Future<void> _ensureFavoritesLoaded() async {
    if (!_isLoaded || state is FavoritesError) {
      await loadFavorites();
    }
  }

  Future<void> addFavorite(User user) async {
    await _ensureFavoritesLoaded();

    if (state is! FavoritesSuccess) return;
    final currentState = state as FavoritesSuccess;

    if (currentState.allFavorites.any((u) => u.uuid == user.uuid)) return;

    final newAllList = List<User>.from(currentState.allFavorites)..add(user);
    newAllList.sort((a, b) => a.firstName.compareTo(b.firstName));

    final newFilteredList = _searchFavoritesUseCase(SearchFavoritesParams(favorites: newAllList, query: _currentQuery));

    emit(FavoritesSuccess(allFavorites: newAllList, filteredFavorites: newFilteredList));

    try {
      await _addFavoritesUseCase(user);
    } catch (e) {
      emit(FavoritesError("Failed to add favorite: $e"));
      emit(currentState);
    }
  }

  Future<void> removeFavorite(String userId) async {
    await _ensureFavoritesLoaded();

    if (state is! FavoritesSuccess) return;
    final currentState = state as FavoritesSuccess;

    final newAllList = List<User>.from(currentState.allFavorites)..removeWhere((u) => u.uuid == userId);

    final newFilteredList = _searchFavoritesUseCase(SearchFavoritesParams(favorites: newAllList, query: _currentQuery));

    emit(FavoritesSuccess(allFavorites: newAllList, filteredFavorites: newFilteredList));

    try {
      await _removeFavoritesUseCase(userId);
    } catch (e) {
      emit(FavoritesError("Failed to remove favorite: $e"));
      emit(currentState);
    }
  }

  Future<void> loadFavorites({bool forceRefresh = false}) async {
    if (_isLoaded && state is FavoritesSuccess && !forceRefresh) {
      return;
    }

    try {
      final favorites = await _getFavoritesUseCase();
      favorites.sort((a, b) => a.firstName.compareTo(b.firstName));

      _currentQuery = '';
      _isLoaded = true;
      emit(FavoritesSuccess(allFavorites: favorites, filteredFavorites: favorites));
    } catch (e) {
      emit(FavoritesError("Failed to load favorites: $e"));
    }
  }

  void searchFavorites(String query) {
    if (state is! FavoritesSuccess) return;

    _currentQuery = query;
    final currentState = state as FavoritesSuccess;

    final filteredList = _searchFavoritesUseCase(
      SearchFavoritesParams(favorites: currentState.allFavorites, query: _currentQuery),
    );

    emit(currentState.copyWith(filteredFavorites: filteredList));
  }
}
