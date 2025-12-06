import '../models/user_model.dart';

/// Local data source for authentication
/// Handles user session storage
abstract class AuthLocalDataSource {
  Future<UserModel?> getCurrentUser();
  Future<void> saveUser(UserModel user);
  Future<void> clearUser();
  Future<bool> isLoggedIn();
}

/// In-memory implementation of AuthLocalDataSource
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  UserModel? _currentUser;

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    _currentUser = user;
  }

  @override
  Future<void> clearUser() async {
    _currentUser = null;
  }

  @override
  Future<bool> isLoggedIn() async {
    return _currentUser != null;
  }
}

