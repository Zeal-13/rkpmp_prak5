import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for settings
/// Uses SharedPreferences for persistence
abstract class SettingsLocalDataSource {
  Future<bool> getNotificationsEnabled();
  Future<void> setNotificationsEnabled(bool enabled);
  Future<bool> getDarkTheme();
  Future<void> setDarkTheme(bool enabled);
  Future<bool> getRememberMe();
  Future<void> setRememberMe(bool remember);
}

/// SharedPreferences implementation of SettingsLocalDataSource
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences _prefs;

  SettingsLocalDataSourceImpl(this._prefs);

  static const String _keyNotifications = 'notifications_enabled';
  static const String _keyDarkTheme = 'dark_theme';
  static const String _keyRememberMe = 'remember_me';

  @override
  Future<bool> getNotificationsEnabled() async {
    return _prefs.getBool(_keyNotifications) ?? true;
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_keyNotifications, enabled);
  }

  @override
  Future<bool> getDarkTheme() async {
    return _prefs.getBool(_keyDarkTheme) ?? false;
  }

  @override
  Future<void> setDarkTheme(bool enabled) async {
    await _prefs.setBool(_keyDarkTheme, enabled);
  }

  @override
  Future<bool> getRememberMe() async {
    return _prefs.getBool(_keyRememberMe) ?? false;
  }

  @override
  Future<void> setRememberMe(bool remember) async {
    await _prefs.setBool(_keyRememberMe, remember);
  }
}

