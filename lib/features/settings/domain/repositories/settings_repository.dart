/// Repository interface for Settings
/// Defines the contract for user settings storage
abstract class SettingsRepository {
  /// Get notifications enabled status
  Future<bool> getNotificationsEnabled();

  /// Set notifications enabled status
  Future<void> setNotificationsEnabled(bool enabled);

  /// Get dark theme status
  Future<bool> getDarkTheme();

  /// Set dark theme status
  Future<void> setDarkTheme(bool enabled);

  /// Get remember me status
  Future<bool> getRememberMe();

  /// Set remember me status
  Future<void> setRememberMe(bool remember);
}

