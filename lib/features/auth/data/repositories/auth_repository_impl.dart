import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/user_model.dart';

/// Implementation of AuthRepository
/// Bridges domain layer with data layer
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    // Simulate login logic (in real app, this would call an API)
    // For now, just create a user from email
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: email.split('@')[0],
      createdAt: DateTime.now(),
    );

    await localDataSource.saveUser(user);
    return user;
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simulate registration logic (in real app, this would call an API)
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      createdAt: DateTime.now(),
    );

    await localDataSource.saveUser(user);
    return user;
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

