import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dto/reqres_dto.dart';
import '../../../../core/network/api_exception.dart';
import '../models/user_model.dart';

/// Remote data source для работы с ReqRes API
/// API: https://reqres.in/
abstract class AuthRemoteDataSource {
  /// Регистрация нового пользователя
  Future<UserModel> register({
    required String email,
    required String password,
    String? name,
  });

  /// Вход пользователя
  Future<UserModel> login({
    required String email,
    required String password,
  });
}

/// Реализация AuthRemoteDataSource с использованием ReqRes API и Dio
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  static const String _baseUrl = 'https://reqres.in/api';

  AuthRemoteDataSourceImpl({DioClient? client})
      : dioClient = client ??
            DioClient(
              baseUrl: _baseUrl,
              headers: {'Content-Type': 'application/json'},
            );

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      // Используем DTO для запроса
      final requestDto = ReqResRegisterRequestDto(
        email: email,
        password: password,
      );

      final response = await dioClient.post(
        '/register',
        body: requestDto.toJson(),
      );

      // Используем DTO для парсинга ответа
      final responseDto = ReqResRegisterResponseDto.fromJson(response);

      if (responseDto.error != null) {
        throw Exception(responseDto.error!);
      }

      if (responseDto.token == null || responseDto.id == null) {
        throw Exception('Неверный ответ от сервера: токен или ID не получены');
      }

      // Создаем пользователя с данными из ответа
      return UserModel(
        id: responseDto.id!.toString(),
        email: email,
        name: name ?? email.split('@').first,
        createdAt: DateTime.now(),
      );
    } on ApiException catch (e) {
      // Передаем сообщение об ошибке от API
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Ошибка при регистрации: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Используем DTO для запроса
      final requestDto = ReqResLoginRequestDto(
        email: email,
        password: password,
      );

      final response = await dioClient.post(
        '/login',
        body: requestDto.toJson(),
      );

      // Используем DTO для парсинга ответа
      final responseDto = ReqResLoginResponseDto.fromJson(response);

      if (responseDto.error != null) {
        throw Exception(responseDto.error!);
      }

      if (responseDto.token == null) {
        throw Exception('Неверный ответ от сервера: токен не получен');
      }

      // Для получения данных пользователя используем отдельный запрос
      // В реальном приложении токен можно использовать для получения профиля
      // Здесь используем email для создания базового пользователя
      return UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: email.split('@').first,
        createdAt: DateTime.now(),
      );
    } on ApiException catch (e) {
      // Передаем сообщение об ошибке от API
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Ошибка при входе: ${e.toString()}');
    }
  }
}

