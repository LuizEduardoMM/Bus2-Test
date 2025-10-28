import 'package:bloc_test/bloc_test.dart';
import 'package:bus2_test/modules/core/domain/entities/user.dart';
import 'package:bus2_test/modules/core/domain/use_cases/add_favorites_usecase.dart';
import 'package:bus2_test/modules/core/domain/use_cases/get_favorites_usecase.dart';
import 'package:bus2_test/modules/core/domain/use_cases/remove_favorites_usecase.dart';
import 'package:bus2_test/modules/core/domain/use_cases/search_favorites_usecase.dart';
import 'package:bus2_test/modules/core/presentation/cubit/favorites_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'favorites_cubit_test.mocks.dart';

@GenerateMocks([AddFavoritesUseCase, GetFavoritesUseCase, RemoveFavoritesUseCase, SearchFavoritesUseCase])
void main() {
  late MockAddFavoritesUseCase mockAddFavoritesUseCase;
  late MockGetFavoritesUseCase mockGetFavoritesUseCase;
  late MockRemoveFavoritesUseCase mockRemoveFavoritesUseCase;
  late MockSearchFavoritesUseCase mockSearchFavoritesUseCase;
  late FavoritesCubit favoritesCubit;

  final tUser = User(
    uuid: '1',
    firstName: 'Eduardo',
    lastName: 'Marrano',
    email: 'test@email.com',
    phone: '12345678',
    pictureLarge: '',
    city: 'New York',
    state: 'Ny',
    country: 'US',
    gender: 'Male',
    age: 25,
    nationality: 'US',
    street: ' Main St',
    streetNumber: 100,
    username: 'Dude123',
  );

  final tUser2 = User(
    uuid: '2',
    firstName: 'Ana',
    lastName: 'Silva',
    email: 'ana.silva@email.com',
    phone: '87654321',
    pictureLarge: '',
    city: 'São Paulo',
    state: 'SP',
    country: 'BR',
    gender: 'Female',
    age: 30,
    nationality: 'BR',
    street: 'Avenida Paulista',
    streetNumber: 500,
    username: 'AnaS',
  );

  final tException = Exception('Failed');

  mockSearchUseCase(List<User> Function(SearchFavoritesParams) answer) {
    when(mockSearchFavoritesUseCase.call(any)).thenAnswer((invocation) {
      final params = invocation.positionalArguments.first as SearchFavoritesParams;
      return answer(params);
    });
  }

  mockSearchUseCasePassthrough() {
    mockSearchUseCase((params) => params.favorites);
  }

  setUp(() {
    mockAddFavoritesUseCase = MockAddFavoritesUseCase();
    mockGetFavoritesUseCase = MockGetFavoritesUseCase();
    mockRemoveFavoritesUseCase = MockRemoveFavoritesUseCase();
    mockSearchFavoritesUseCase = MockSearchFavoritesUseCase();

    mockSearchUseCasePassthrough();

    favoritesCubit = FavoritesCubit(
      mockAddFavoritesUseCase,
      mockGetFavoritesUseCase,
      mockRemoveFavoritesUseCase,
      mockSearchFavoritesUseCase,
    );
  });

  tearDown(() {
    favoritesCubit.close();
  });

  test('initial state should be FavoritesInitial', () {
    expect(favoritesCubit.state, equals(FavoritesInitial()));
  });

  group('loadFavorites', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'should load and emit [FavoritesSuccess] when loadFavorites is called',
      setUp: () {
        when(mockGetFavoritesUseCase.call()).thenAnswer((_) async => [tUser, tUser2]);
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.loadFavorites(),
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser2, tUser], filteredFavorites: [tUser2, tUser]),
      ],
      verify: (_) {
        verify(mockGetFavoritesUseCase.call()).called(1);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'should emit [FavoritesError] when loadFavorites fails',
      setUp: () {
        when(mockGetFavoritesUseCase.call()).thenThrow(tException);
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.loadFavorites(),
      expect: () => [FavoritesError("Failed to load favorites: $tException")],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'should not call use case twice if loadFavorites is called multiple times',
      setUp: () {
        when(mockGetFavoritesUseCase.call()).thenAnswer((_) async => [tUser]);
      },
      build: () => favoritesCubit,
      act: (cubit) async {
        await cubit.loadFavorites();
        await cubit.loadFavorites();
      },
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser], filteredFavorites: [tUser]),
      ],
      verify: (_) {
        verify(mockGetFavoritesUseCase.call()).called(1);
      },
    );
  });

  group('addFavorite', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'should load favorites first when addFavorite is called from Initial state',
      setUp: () {
        when(mockGetFavoritesUseCase.call()).thenAnswer((_) async => [tUser2]);
        when(mockAddFavoritesUseCase.call(tUser)).thenAnswer((_) async {});
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.addFavorite(tUser),
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser2], filteredFavorites: [tUser2]),
        FavoritesSuccess(allFavorites: [tUser2, tUser], filteredFavorites: [tUser2, tUser]),
      ],
      verify: (_) {
        verify(mockGetFavoritesUseCase.call()).called(1);
        verify(mockAddFavoritesUseCase.call(tUser)).called(1);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'should revert to previous state if addFavorite use case fails',
      seed: () => FavoritesSuccess(allFavorites: [tUser2], filteredFavorites: [tUser2]),
      setUp: () {
        when(mockAddFavoritesUseCase.call(tUser)).thenThrow(tException);
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.addFavorite(tUser),
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser2, tUser], filteredFavorites: [tUser2, tUser]),
        FavoritesError("Failed to add favorite: $tException"),
        FavoritesSuccess(allFavorites: [tUser2], filteredFavorites: [tUser2]),
      ],
      verify: (_) {
        verify(mockAddFavoritesUseCase.call(tUser)).called(1);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'should not emit new state or call use case if adding a duplicate user',
      seed: () => FavoritesSuccess(allFavorites: [tUser, tUser2], filteredFavorites: [tUser, tUser2]),
      build: () => favoritesCubit,
      act: (cubit) => cubit.addFavorite(tUser),
      expect: () => [],
      verify: (_) {
        verifyNever(mockAddFavoritesUseCase.call(any));
      },
    );
  });

  group('removeFavorite', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'should optimistically remove user when removeFavorite is called',
      seed: () => FavoritesSuccess(allFavorites: [tUser, tUser2], filteredFavorites: [tUser, tUser2]),
      setUp: () {
        when(mockRemoveFavoritesUseCase.call(tUser.uuid)).thenAnswer((_) async {});
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.removeFavorite(tUser.uuid),
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser2], filteredFavorites: [tUser2]),
      ],
      verify: (_) {
        verify(mockRemoveFavoritesUseCase.call(tUser.uuid)).called(1);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'should revert to previous state if removeFavorite use case fails',
      seed: () => FavoritesSuccess(allFavorites: [tUser, tUser2], filteredFavorites: [tUser, tUser2]),
      setUp: () {
        when(mockRemoveFavoritesUseCase.call(tUser.uuid)).thenThrow(tException);
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.removeFavorite(tUser.uuid),
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser2], filteredFavorites: [tUser2]),
        FavoritesError("Failed to remove favorite: $tException"),
        FavoritesSuccess(allFavorites: [tUser, tUser2], filteredFavorites: [tUser, tUser2]),
      ],
      verify: (_) {
        verify(mockRemoveFavoritesUseCase.call(tUser.uuid)).called(1);
      },
    );
  });

  group('searchFavorites', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'should emit filtered list when searchFavorites finds a match',
      seed: () => FavoritesSuccess(allFavorites: [tUser, tUser2], filteredFavorites: [tUser, tUser2]),
      setUp: () {
        mockSearchUseCase((params) => params.favorites.where((u) => u.uuid == tUser2.uuid).toList());
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.searchFavorites('Ana'),
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser, tUser2], filteredFavorites: [tUser2]),
      ],
      verify: (_) {
        verify(
          mockSearchFavoritesUseCase.call(SearchFavoritesParams(favorites: [tUser, tUser2], query: 'Ana')),
        ).called(1);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'should emit empty filtered list when searchFavorites finds no match',
      seed: () => FavoritesSuccess(allFavorites: [tUser, tUser2], filteredFavorites: [tUser, tUser2]),
      setUp: () {
        mockSearchUseCase((params) => []);
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.searchFavorites('Zebra'),
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser, tUser2], filteredFavorites: []),
      ],
      verify: (_) {
        verify(
          mockSearchFavoritesUseCase.call(SearchFavoritesParams(favorites: [tUser, tUser2], query: 'Zebra')),
        ).called(1);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'should emit full list when searchFavorites query is empty',
      seed: () => FavoritesSuccess(allFavorites: [tUser, tUser2], filteredFavorites: []),
      setUp: () {
        mockSearchUseCase((params) => params.favorites);
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.searchFavorites(''),
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser, tUser2], filteredFavorites: [tUser, tUser2]),
      ],
    );
  });

  group('Edge cases and integration', () {
    blocTest<FavoritesCubit, FavoritesState>(
      'should sort favorites by firstName when loading',
      setUp: () {
        when(mockGetFavoritesUseCase.call()).thenAnswer((_) async => [tUser, tUser2]);
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.loadFavorites(),
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser2, tUser], filteredFavorites: [tUser2, tUser]),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'should reset search query when reloading favorites',
      seed: () => FavoritesSuccess(allFavorites: [tUser, tUser2], filteredFavorites: [tUser, tUser2]),
      setUp: () {
        when(mockGetFavoritesUseCase.call()).thenAnswer((_) async => [tUser, tUser2]);
      },
      build: () => favoritesCubit,
      act: (cubit) async {
        await cubit.loadFavorites(forceRefresh: true);
      },
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser2, tUser], filteredFavorites: [tUser2, tUser]),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'should handle addFavorite on empty list',
      seed: () => FavoritesSuccess(allFavorites: [], filteredFavorites: []),
      setUp: () {
        when(mockAddFavoritesUseCase.call(tUser)).thenAnswer((_) async {});
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.addFavorite(tUser),
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser], filteredFavorites: [tUser]),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'should maintain allFavorites when searching',
      seed: () => FavoritesSuccess(allFavorites: [tUser, tUser2], filteredFavorites: [tUser, tUser2]),
      setUp: () {
        mockSearchUseCase((params) => [tUser]);
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.searchFavorites('Eduardo'),
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser, tUser2], filteredFavorites: [tUser]),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'should allow retry after error',
      seed: () => FavoritesError("Previous error"),
      setUp: () {
        when(mockGetFavoritesUseCase.call()).thenAnswer((_) async => [tUser]);
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.loadFavorites(),
      expect: () => [
        FavoritesSuccess(allFavorites: [tUser], filteredFavorites: [tUser]),
      ],
    );
  });
}
