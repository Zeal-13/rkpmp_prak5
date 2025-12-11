/// Export Drift implementation
library;
export 'auth_drift_data_source.dart' show AuthDriftDataSource;

import '../models/user_model.dart';

/// Local data source for authentication
/// Handles user session storage
abstract class AuthLocalDataSource {
  Future<UserModel?> getCurrentUser();
  Future<void> saveUser(UserModel user);
  Future<void> clearUser();
  Future<bool> isLoggedIn();
}
