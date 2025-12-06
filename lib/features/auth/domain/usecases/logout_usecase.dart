import '../repositories/auth_repository.dart';

/// Use case: Logout user
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}

