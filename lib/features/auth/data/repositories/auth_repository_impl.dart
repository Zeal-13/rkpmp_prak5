import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      // Выполняем сетевой запрос к ReqRes API
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Сохраняем пользователя локально после успешного входа
      await localDataSource.saveUser(user);
      return user;
    } catch (e) {
      throw Exception('Ошибка при входе: $e');
    }
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Регистрация выполняется локально без API запроса
      // Создаем пользователя локально
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );

      // Сохраняем пользователя локально
      await localDataSource.saveUser(user);
      return user;
    } catch (e) {
      throw Exception('Ошибка при регистрации: $e');
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearUser();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await localDataSource.getCurrentUser();
    return userModel;
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }
}

