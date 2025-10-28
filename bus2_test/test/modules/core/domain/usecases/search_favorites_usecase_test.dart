import 'package:bus2_test/modules/core/domain/entities/user.dart';
import 'package:bus2_test/modules/core/domain/use_cases/search_favorites_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SearchFavoritesUseCase searchFavoritesUseCase;

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

  final tUser3 = User(
    uuid: '3',
    firstName: 'Carlos',
    lastName: 'Eduardo',
    email: 'carlos@email.com',
    phone: '11111111',
    pictureLarge: '',
    city: 'Rio de Janeiro',
    state: 'RJ',
    country: 'BR',
    gender: 'Male',
    age: 35,
    nationality: 'BR',
    street: 'Rua Test',
    streetNumber: 200,
    username: 'CarlosE',
  );

  setUp(() {
    searchFavoritesUseCase = SearchFavoritesUseCase();
  });

  group('SearchFavoritesUseCase', () {
    group('Filter by firstName', () {
      test('should return users matching firstName', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: 'Eduardo');

        final result = searchFavoritesUseCase(params);

        expect(result.length, equals(2));
        expect(result.any((u) => u.uuid == '1'), isTrue);
        expect(result.any((u) => u.uuid == '3'), isTrue);
      });

      test('should return user with exact firstName match', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: 'Ana');

        final result = searchFavoritesUseCase(params);

        expect(result.length, equals(1));
        expect(result.first.uuid, equals('2'));
      });
    });

    group('Filter by lastName', () {
      test('should return users matching lastName', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: 'Silva');

        final result = searchFavoritesUseCase(params);

        expect(result.length, equals(1));
        expect(result.first.uuid, equals('2'));
      });
    });

    group('Filter by email', () {
      test('should return users matching email', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: 'test@email.com');

        final result = searchFavoritesUseCase(params);

        expect(result.length, equals(1));
        expect(result.first.uuid, equals('1'));
      });

      test('should return users matching partial email', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: '@email.com');

        final result = searchFavoritesUseCase(params);

        expect(result.length, equals(3));
        expect(result.any((u) => u.uuid == '1'), isTrue);
        expect(result.any((u) => u.uuid == '2'), isTrue);
        expect(result.any((u) => u.uuid == '3'), isTrue);
      });
    });

    group('Case insensitivity', () {
      test('should be case insensitive for firstName', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: 'EDUARDO');

        final result = searchFavoritesUseCase(params);

        expect(result.length, equals(2));
      });

      test('should be case insensitive for email', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: 'TEST@EMAIL.COM');

        final result = searchFavoritesUseCase(params);

        expect(result.length, equals(1));
        expect(result.first.uuid, equals('1'));
      });

      test('should be case insensitive for lastName', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: 'silva');

        final result = searchFavoritesUseCase(params);

        expect(result.length, equals(1));
        expect(result.first.uuid, equals('2'));
      });
    });

    group('Empty and edge cases', () {
      test('should return all users when query is empty', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: '');

        final result = searchFavoritesUseCase(params);

        expect(result.length, equals(3));
      });

      test('should return empty list when no match found', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: 'Zebra');

        final result = searchFavoritesUseCase(params);

        expect(result.isEmpty, isTrue);
      });

      test('should return empty list when favorites list is empty', () {
        final params = SearchFavoritesParams(favorites: [], query: 'Eduardo');

        final result = searchFavoritesUseCase(params);

        expect(result.isEmpty, isTrue);
      });

      test('should handle single character query', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: 'A');

        final result = searchFavoritesUseCase(params);

        expect(result.isNotEmpty, isTrue);
        expect(result.any((u) => u.firstName.contains('A')), isTrue);
      });
    });

    group('Complex scenarios', () {
      test('should filter multiple matches in different fields', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: 'a');

        final result = searchFavoritesUseCase(params);

        expect(result.length, greaterThan(0));
      });

      test('should maintain original order of results', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: 'e');

        final result = searchFavoritesUseCase(params);

        final uuids = result.map((u) => u.uuid).toList();
        expect(uuids[0], equals('1'));
      });

      test('should search with spaces in query', () {
        final params = SearchFavoritesParams(favorites: [tUser, tUser2, tUser3], query: 'Eduardo Marrano');

        final result = searchFavoritesUseCase(params);

        expect(result.length, equals(1));
        expect(result.first.uuid, equals('1'));
      });
    });
  });
}
