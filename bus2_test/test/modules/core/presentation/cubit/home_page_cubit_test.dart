import 'package:bloc_test/bloc_test.dart';
import 'package:bus2_test/modules/core/domain/entities/user.dart';
import 'package:bus2_test/modules/home/domain/use_cases/fetch_user_usecase.dart';
import 'package:bus2_test/modules/home/domain/use_cases/search_user_usecase.dart';
import 'package:bus2_test/modules/home/presentation/cubit/home_page_cubit.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_page_cubit_test.mocks.dart';

@GenerateMocks([FetchNewUserUseCase, SearchHomeUseCase, TickerProvider])
void main() {
  late MockFetchNewUserUseCase mockFetchNewUserUseCase;
  late MockSearchHomeUseCase mockSearchHomeUseCase;
  late HomePageCubit homePageCubit;
  late MockTickerProvider mockTickerProvider;

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
    street: 'Main St',
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

  _mockSearchUseCase(List<User> Function(SearchHomeParams) answer) {
    when(mockSearchHomeUseCase.call(any)).thenAnswer((invocation) {
      final params = invocation.positionalArguments.first as SearchHomeParams;
      return answer(params);
    });
  }

  _mockSearchUseCasePassthrough() {
    _mockSearchUseCase((params) => params.allUsers);
  }

  setUp(() {
    mockFetchNewUserUseCase = MockFetchNewUserUseCase();
    mockSearchHomeUseCase = MockSearchHomeUseCase();
    mockTickerProvider = MockTickerProvider();

    _mockSearchUseCasePassthrough();

    homePageCubit = HomePageCubit(mockFetchNewUserUseCase, mockSearchHomeUseCase);
  });

  tearDown(() {
    homePageCubit.close();
  });

  test('initial state should be HomeInitial', () {
    expect(homePageCubit.state, equals(HomeInitial()));
  });

  group('getNextUser', () {
    blocTest<HomePageCubit, HomeState>(
      'should emit HomeSuccess when getNextUser succeeds',
      setUp: () {
        when(mockFetchNewUserUseCase.call()).thenAnswer((_) async => tUser);
      },
      build: () => homePageCubit,
      act: (cubit) => cubit.getNextUser(),
      expect: () => [
        HomeSuccess(allUsers: [tUser], filteredUsers: [tUser]),
      ],
      verify: (_) {
        verify(mockFetchNewUserUseCase.call()).called(1);
      },
    );

    blocTest<HomePageCubit, HomeState>(
      'should prepend new user to existing list',
      seed: () => HomeSuccess(allUsers: [tUser2], filteredUsers: [tUser2]),
      setUp: () {
        when(mockFetchNewUserUseCase.call()).thenAnswer((_) async => tUser);
      },
      build: () => homePageCubit,
      act: (cubit) => cubit.getNextUser(),
      expect: () => [
        HomeSuccess(allUsers: [tUser, tUser2], filteredUsers: [tUser, tUser2]),
      ],
    );

    blocTest<HomePageCubit, HomeState>(
      'should emit HomeError when fetch fails',
      setUp: () {
        when(mockFetchNewUserUseCase.call()).thenThrow(tException);
      },
      build: () => homePageCubit,
      act: (cubit) => cubit.getNextUser(),
      expect: () => [HomeError('Falha ao buscar novo usuário: $tException')],
    );
  });

  group('searchUsers', () {
    blocTest<HomePageCubit, HomeState>(
      'should filter users when search query matches',
      seed: () => HomeSuccess(allUsers: [tUser, tUser2], filteredUsers: [tUser, tUser2]),
      setUp: () {
        _mockSearchUseCase((params) => params.allUsers.where((u) => u.firstName.contains('Ana')).toList());
      },
      build: () => homePageCubit,
      act: (cubit) => cubit.searchUsers('Ana', mockTickerProvider),
      expect: () => [
        HomeSuccess(allUsers: [tUser, tUser2], filteredUsers: [tUser2]),
      ],
    );

    blocTest<HomePageCubit, HomeState>(
      'should return empty list when no match',
      seed: () => HomeSuccess(allUsers: [tUser, tUser2], filteredUsers: [tUser, tUser2]),
      setUp: () {
        _mockSearchUseCase((params) => []);
      },
      build: () => homePageCubit,
      act: (cubit) => cubit.searchUsers('Zebra', mockTickerProvider),
      expect: () => [
        HomeSuccess(allUsers: [tUser, tUser2], filteredUsers: []),
      ],
    );

    blocTest<HomePageCubit, HomeState>(
      'should not update if state is not HomeSuccess',
      seed: () => HomeInitial(),
      build: () => homePageCubit,
      act: (cubit) => cubit.searchUsers('Ana', mockTickerProvider),
      expect: () => [],
      verify: (_) {
        verifyNever(mockSearchHomeUseCase.call(any));
      },
    );

    blocTest<HomePageCubit, HomeState>(
      'should maintain allUsers when searching',
      seed: () => HomeSuccess(allUsers: [tUser, tUser2], filteredUsers: [tUser, tUser2]),
      setUp: () {
        _mockSearchUseCase((params) => [tUser]);
      },
      build: () => homePageCubit,
      act: (cubit) => cubit.searchUsers('Eduardo', mockTickerProvider),
      expect: () => [
        HomeSuccess(allUsers: [tUser, tUser2], filteredUsers: [tUser]),
      ],
    );
  });

  group('resetSearch', () {
    blocTest<HomePageCubit, HomeState>(
      'should clear query and show all users',
      seed: () => HomeSuccess(allUsers: [tUser, tUser2], filteredUsers: [tUser2]),
      setUp: () {
        _mockSearchUseCase((params) => params.allUsers);
      },
      build: () => homePageCubit,
      act: (cubit) => cubit.resetSearch(mockTickerProvider),
      expect: () => [
        HomeSuccess(allUsers: [tUser, tUser2], filteredUsers: [tUser, tUser2]),
      ],
    );
  });

  group('stopFetchingUsers', () {
    blocTest<HomePageCubit, HomeState>(
      'should stop ticker without changing state',
      seed: () => HomeSuccess(allUsers: [tUser], filteredUsers: [tUser]),
      build: () => homePageCubit,
      act: (cubit) => cubit.stopFetchingUsers(),
      expect: () => [],
    );
  });

  group('Edge cases and integration', () {
    blocTest<HomePageCubit, HomeState>(
      'should handle getNextUser on error state',
      seed: () => HomeError('Previous error'),
      setUp: () {
        when(mockFetchNewUserUseCase.call()).thenAnswer((_) async => tUser);
      },
      build: () => homePageCubit,
      act: (cubit) => cubit.getNextUser(),
      expect: () => [
        HomeSuccess(allUsers: [tUser], filteredUsers: [tUser]),
      ],
    );

    blocTest<HomePageCubit, HomeState>(
      'should handle multiple searches in sequence',
      seed: () => HomeSuccess(allUsers: [tUser, tUser2], filteredUsers: [tUser, tUser2]),
      setUp: () {
        _mockSearchUseCase((params) {
          if (params.query.contains('Eduardo')) {
            return params.allUsers.where((u) => u.firstName.contains('Eduardo')).toList();
          } else if (params.query.contains('Ana')) {
            return params.allUsers.where((u) => u.firstName.contains('Ana')).toList();
          }
          return params.allUsers;
        });
      },
      build: () => homePageCubit,
      act: (cubit) async {
        cubit.searchUsers('Eduardo', mockTickerProvider);
        cubit.searchUsers('Ana', mockTickerProvider);
        cubit.searchUsers('', mockTickerProvider);
      },
      expect: () => [
        HomeSuccess(allUsers: [tUser, tUser2], filteredUsers: [tUser]),
        HomeSuccess(allUsers: [tUser, tUser2], filteredUsers: [tUser2]),
        HomeSuccess(allUsers: [tUser, tUser2], filteredUsers: [tUser, tUser2]),
      ],
    );
  });
}
