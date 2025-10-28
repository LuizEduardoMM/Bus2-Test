import 'package:bus2_test/modules/core/data/models/user_model.dart';
import 'package:bus2_test/modules/home/data/datasources/home_page_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_page_datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late HomePageDatasourceImpl datasource;
  late MockDio mockDio;

  final tUserMap = {
    'login': {'username': 'testuser'},
    'name': {'first': 'Eduardo', 'last': 'Marrano'},
    'email': 'test@example.com',
    'phone': '12345678',
    'picture': {'large': 'https://example.com/photo.jpg'},
    'location': {
      'street': {'name': 'Main Street', 'number': 100},
      'city': 'New York',
      'state': 'NY',
      'country': 'US',
    },
    'gender': 'male',
    'dob': {'age': 25},
    'nat': 'US',
    'id': {'value': '1'},
  };

  final tUserMap2 = {
    'login': {'username': 'anadoe'},
    'name': {'first': 'Ana', 'last': 'Silva'},
    'email': 'ana@example.com',
    'phone': '87654321',
    'picture': {'large': 'https://example.com/photo2.jpg'},
    'location': {
      'street': {'name': 'Avenida Paulista', 'number': 500},
      'city': 'São Paulo',
      'state': 'SP',
      'country': 'BR',
    },
    'gender': 'female',
    'dob': {'age': 30},
    'nat': 'BR',
    'id': {'value': '2'},
  };

  setUp(() {
    mockDio = MockDio();
    datasource = HomePageDatasourceImpl(mockDio);
  });

  group('HomePageDatasource', () {
    group('fetchNewUser success', () {
      test('should return UserModel when API call succeeds', () async {
        final responseData = {
          'results': [tUserMap],
        };

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final result = await datasource.fetchNewUser();

        expect(result, isA<UserModel>());
        expect(result.firstName, equals('Eduardo'));
        expect(result.lastName, equals('Marrano'));
        expect(result.email, equals('test@example.com'));
      });

      test('should parse user data correctly', () async {
        final responseData = {
          'results': [tUserMap],
        };

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final result = await datasource.fetchNewUser();

        expect(result.username, equals('testuser'));
        expect(result.phone, equals('12345678'));
        expect(result.city, equals('New York'));
        expect(result.state, equals('NY'));
        expect(result.country, equals('US'));
        expect(result.gender, equals('male'));
        expect(result.age, equals(25));
      });

      test('should call API with correct URL', () async {
        final responseData = {
          'results': [tUserMap],
        };

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        await datasource.fetchNewUser();

        verify(mockDio.get('https://randomuser.me/api/')).called(1);
      });
    });

    group('fetchNewUser error handling', () {
      test('should throw exception when statusCode is not 200', () async {
        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: {},
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        expect(
          () => datasource.fetchNewUser(),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Falha ao carregar usuário: 500'))),
        );
      });

      test('should throw exception when results list is empty', () async {
        final responseData = {'results': []};

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        expect(
          () => datasource.fetchNewUser(),
          throwsA(
            isA<Exception>().having((e) => e.toString(), 'message', contains('Nenhum usuário encontrado na resposta')),
          ),
        );
      });

      test('should throw exception on DioException', () async {
        when(mockDio.get(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Network error',
            type: DioExceptionType.connectionTimeout,
          ),
        );

        expect(
          () => datasource.fetchNewUser(),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Erro de rede ao buscar usuário'))),
        );
      });

      test('should throw exception on generic exception', () async {
        when(mockDio.get(any)).thenThrow(Exception('Unexpected error'));

        expect(
          () => datasource.fetchNewUser(),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Erro inesperado'))),
        );
      });
    });

    group('fetchNewUser data validation', () {
      test('should parse multiple user fields correctly', () async {
        final responseData = {
          'results': [tUserMap2],
        };

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final result = await datasource.fetchNewUser();

        expect(result.firstName, equals('Ana'));
        expect(result.lastName, equals('Silva'));
        expect(result.email, equals('ana@example.com'));
        expect(result.phone, equals('87654321'));
        expect(result.city, equals('São Paulo'));
        expect(result.state, equals('SP'));
        expect(result.country, equals('BR'));
        expect(result.gender, equals('female'));
        expect(result.age, equals(30));
        expect(result.nationality, equals('BR'));
      });

      test('should use first result when multiple users returned', () async {
        final responseData = {
          'results': [tUserMap, tUserMap2],
        };

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final result = await datasource.fetchNewUser();

        expect(result.firstName, equals('Eduardo'));
      });
    });
  });
}
