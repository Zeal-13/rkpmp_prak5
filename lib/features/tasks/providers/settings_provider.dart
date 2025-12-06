import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings {
  final bool notificationsEnabled;
  final bool isDarkTheme;

  Settings({
    this.notificationsEnabled = true,
    this.isDarkTheme = false,
  });

  Settings copyWith({
    bool? notificationsEnabled,
    bool? isDarkTheme,
  }) {
    return Settings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
    );
  }
}

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings());

  void updateSettings({bool? notifications, bool? darkTheme}) {
    state = state.copyWith(
      notificationsEnabled: notifications,
      isDarkTheme: darkTheme,
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  return SettingsNotifier();
});

