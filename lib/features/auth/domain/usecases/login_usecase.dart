import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case: Login user
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    // Business logic validation
    if (email.isEmpty || !email.contains('@')) {
      throw ArgumentError('Invalid email format');
    }
    if (password.isEmpty || password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }

    return await repository.login(email, password);
  }
}

