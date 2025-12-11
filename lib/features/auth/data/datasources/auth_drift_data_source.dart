import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../models/user_model.dart';
import 'auth_local_data_source.dart';

/// Drift (SQL) implementation of AuthLocalDataSource
class AuthDriftDataSource implements AuthLocalDataSource {
  final AppDatabase _database;

  AuthDriftDataSource(this._database);

  @override
  Future<UserModel?> getCurrentUser() async {
    // Get the first (and should be only) user from database
    final query = _database.select(_database.users);
    final users = await query.get();
    
    if (users.isEmpty) {
      return null;
    }
    
    // Get the most recent user (if multiple exist)
    final userData = users.reduce((a, b) => 
      a.createdAt.isAfter(b.createdAt) ? a : b
    );
    
    return _rowToModel(userData);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    // Delete existing users (only one user session at a time)
    await _database.delete(_database.users).go();
    
    // Insert new user
    await _database.into(_database.users).insert(_modelToRow(user));
  }

  @override
  Future<void> clearUser() async {
    await _database.delete(_database.users).go();
  }

  @override
  Future<bool> isLoggedIn() async {
    final users = await _database.select(_database.users).get();
    return users.isNotEmpty;
  }

  /// Convert Drift row to UserModel
  UserModel _rowToModel(User row) {
    return UserModel(
      id: row.id,
      email: row.email,
      name: row.name,
      createdAt: row.createdAt,
    );
  }

  /// Convert UserModel to Drift row
  UsersCompanion _modelToRow(UserModel model) {
    return UsersCompanion(
      id: Value(model.id),
      email: Value(model.email),
      name: Value(model.name),
      createdAt: Value(model.createdAt),
    );
  }
}

