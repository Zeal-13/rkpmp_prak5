import '../entities/user_entity.dart';

/// Repository interface for Authentication
/// Defines the contract for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  Future<UserEntity> login(String email, String password);

  /// Register a new user
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  });

  /// Logout current user
  Future<void> logout();

  /// Get current user
  Future<UserEntity?> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}

