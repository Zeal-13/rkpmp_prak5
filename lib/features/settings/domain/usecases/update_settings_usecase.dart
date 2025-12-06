import '../repositories/settings_repository.dart';

/// Use case: Update user settings
class UpdateSettingsUseCase {
  final SettingsRepository repository;

  UpdateSettingsUseCase(this.repository);

  Future<void> call({
    bool? notificationsEnabled,
    bool? darkTheme,
    bool? rememberMe,
  }) async {
    if (notificationsEnabled != null) {
      await repository.setNotificationsEnabled(notificationsEnabled);
    }
    if (darkTheme != null) {
      await repository.setDarkTheme(darkTheme);
    }
    if (rememberMe != null) {
      await repository.setRememberMe(rememberMe);
    }
  }
}

