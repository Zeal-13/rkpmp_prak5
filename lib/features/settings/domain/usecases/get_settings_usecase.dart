import '../repositories/settings_repository.dart';

/// Use case: Get user settings
class GetSettingsUseCase {
  final SettingsRepository repository;

  GetSettingsUseCase(this.repository);

  Future<SettingsModel> call() async {
    final notifications = await repository.getNotificationsEnabled();
    final darkTheme = await repository.getDarkTheme();
    final rememberMe = await repository.getRememberMe();

    return SettingsModel(
      notificationsEnabled: notifications,
      darkTheme: darkTheme,
      rememberMe: rememberMe,
    );
  }
}

class SettingsModel {
  final bool notificationsEnabled;
  final bool darkTheme;
  final bool rememberMe;

  SettingsModel({
    required this.notificationsEnabled,
    required this.darkTheme,
    required this.rememberMe,
  });
}

