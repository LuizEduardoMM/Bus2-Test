part of 'favorites_cubit.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);

  @override
  List<Object> get props => [message];
}

class FavoritesSuccess extends FavoritesState {
  final List<User> allFavorites;
  final List<User> filteredFavorites;

  const FavoritesSuccess({required this.allFavorites, required this.filteredFavorites});

  @override
  List<Object> get props => [allFavorites, filteredFavorites];

  FavoritesSuccess copyWith({List<User>? allFavorites, List<User>? filteredFavorites}) {
    return FavoritesSuccess(
      allFavorites: allFavorites ?? this.allFavorites,
      filteredFavorites: filteredFavorites ?? this.filteredFavorites,
    );
  }
}
