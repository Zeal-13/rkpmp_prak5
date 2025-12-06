import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case: Get current logged in user
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UserEntity?> call() async {
    return await repository.getCurrentUser();
  }
}

