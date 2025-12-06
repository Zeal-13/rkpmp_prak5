import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

/// Implementation of SettingsRepository
/// Bridges domain layer with data layer
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<bool> getNotificationsEnabled() async {
    return await localDataSource.getNotificationsEnabled();
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    await localDataSource.setNotificationsEnabled(enabled);
  }

  @override
  Future<bool> getDarkTheme() async {
    return await localDataSource.getDarkTheme();
  }

  @override
  Future<void> setDarkTheme(bool enabled) async {
    await localDataSource.setDarkTheme(enabled);
  }

  @override
  Future<bool> getRememberMe() async {
    return await localDataSource.getRememberMe();
  }

  @override
  Future<void> setRememberMe(bool remember) async {
    await localDataSource.setRememberMe(remember);
  }
}

