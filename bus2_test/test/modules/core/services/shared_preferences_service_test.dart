import 'package:bus2_test/modules/core/data/models/user_model.dart';
import 'package:bus2_test/modules/core/data/services/shared_preferences_service.dart';
import 'package:bus2_test/modules/core/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferencesService service;
  late SharedPreferences prefs;

  final tUserModel = UserModel(
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

  final tUserModel2 = UserModel(
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

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    service = SharedPreferencesService();
  });

  tearDown(() async {
    await prefs.clear();
  });

  group('saveFavorite', () {
    test('should save favorite to SharedPreferences', () async {
      await service.saveFavorite(tUserModel);

      final favorites = await service.getFavorites();

      expect(favorites.length, equals(1));
      expect(favorites.first.uuid, equals(tUserModel.uuid));
      expect(favorites.first.firstName, equals('Eduardo'));
    });

    test('should not save duplicate favorite', () async {
      await service.saveFavorite(tUserModel);
      await service.saveFavorite(tUserModel);
      final favorites = await service.getFavorites();

      expect(favorites.length, equals(1));
    });

    test('should append new favorite to existing list', () async {
      await service.saveFavorite(tUserModel);
      await service.saveFavorite(tUserModel2);

      final favorites = await service.getFavorites();

      expect(favorites.length, equals(2));
      expect(favorites.any((u) => u.uuid == '1'), isTrue);
      expect(favorites.any((u) => u.uuid == '2'), isTrue);
    });
  });

  group('removeFavorite', () {
    test('should remove favorite from SharedPreferences', () async {
      await service.saveFavorite(tUserModel);
      await service.saveFavorite(tUserModel2);

      await service.removeFavorite(tUserModel.uuid);

      final favorites = await service.getFavorites();

      expect(favorites.length, equals(1));
      expect(favorites.first.uuid, equals(tUserModel2.uuid));
    });

    test('should handle remove when favorite does not exist', () async {
      await service.saveFavorite(tUserModel);

      await service.removeFavorite('999');

      final favorites = await service.getFavorites();

      expect(favorites.length, equals(1));
      expect(favorites.first.uuid, equals(tUserModel.uuid));
    });

    test('should remove all favorites when removing last one', () async {
      await service.saveFavorite(tUserModel);
      await service.removeFavorite(tUserModel.uuid);

      final favorites = await service.getFavorites();

      expect(favorites.isEmpty, isTrue);
    });
  });

  group('getFavorites', () {
    test('should return empty list when no favorites saved', () async {
      final favorites = await service.getFavorites();

      expect(favorites, isEmpty);
    });

    test('should return all saved favorites', () async {
      await service.saveFavorite(tUserModel);
      await service.saveFavorite(tUserModel2);

      final favorites = await service.getFavorites();

      expect(favorites.length, equals(2));
    });

    test('should return favorites as User entities', () async {
      await service.saveFavorite(tUserModel);

      final favorites = await service.getFavorites();

      expect(favorites.first, isA<User>());
      expect(favorites.first.firstName, equals('Eduardo'));
    });

    test('should persist favorites across multiple calls', () async {
      await service.saveFavorite(tUserModel);

      final favorites1 = await service.getFavorites();
      final favorites2 = await service.getFavorites();

      expect(favorites1.length, equals(favorites2.length));
      expect(favorites1.first.uuid, equals(favorites2.first.uuid));
    });
  });
}
