import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case: Register new user
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
  }) async {
    // Business logic validation
    if (name.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    if (email.isEmpty || !email.contains('@')) {
      throw ArgumentError('Invalid email format');
    }
    if (password.isEmpty || password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }

    return await repository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}

