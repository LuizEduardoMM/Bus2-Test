import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/data/models/user_model.dart';
import '../../../core/domain/entities/user.dart';

abstract class HomePageDatasource {
  Future<User> fetchNewUser();
}

@Singleton(as: HomePageDatasource)
class HomePageDatasourceImpl implements HomePageDatasource {
  final Dio _dio;
  final String _url = 'https://randomuser.me/api/';

  HomePageDatasourceImpl(this._dio);

  @override
  Future<User> fetchNewUser() async {
    try {
      final response = await _dio.get(_url);

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;

        if (results.isNotEmpty) {
          return UserModel.fromJson(results[0]);
        } else {
          throw Exception('Nenhum usuário encontrado na resposta.');
        }
      } else {
        throw Exception('Falha ao carregar usuário: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Erro de rede ao buscar usuário: $e');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }
}
