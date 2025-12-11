import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import 'auth_local_data_source.dart';

/// SharedPreferences implementation of AuthLocalDataSource для веб
class AuthSharedPrefsDataSource implements AuthLocalDataSource {
  final SharedPreferences _prefs;
  static const String _userKey = 'current_user';

  AuthSharedPrefsDataSource(this._prefs);

  @override
  Future<UserModel?> getCurrentUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) {
      return null;
    }
    try {
      final json = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  @override
  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    return _prefs.containsKey(_userKey);
  }
}


