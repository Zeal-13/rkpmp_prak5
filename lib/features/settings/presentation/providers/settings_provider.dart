import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';
import '../../../../core/di/injection_container.dart';

/// Settings state model
class SettingsState {
  final bool notificationsEnabled;
  final bool darkTheme;
  final bool rememberMe;
  final bool isLoading;
  final String? error;

  SettingsState({
    this.notificationsEnabled = true,
    this.darkTheme = false,
    this.rememberMe = false,
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? darkTheme,
    bool? rememberMe,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkTheme: darkTheme ?? this.darkTheme,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Settings state notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateSettingsUseCase updateSettingsUseCase;

  SettingsNotifier({
    required this.getSettingsUseCase,
    required this.updateSettingsUseCase,
  }) : super(SettingsState()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true);
    try {
      final settings = await getSettingsUseCase();
      state = state.copyWith(
        notificationsEnabled: settings.notificationsEnabled,
        darkTheme: settings.darkTheme,
        rememberMe: settings.rememberMe,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateSettings({
    bool? notificationsEnabled,
    bool? darkTheme,
    bool? rememberMe,
  }) async {
    try {
      await updateSettingsUseCase(
        notificationsEnabled: notificationsEnabled,
        darkTheme: darkTheme,
        rememberMe: rememberMe,
      );
      await loadSettings();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Settings provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(
    getSettingsUseCase: sl<GetSettingsUseCase>(),
    updateSettingsUseCase: sl<UpdateSettingsUseCase>(),
  );
});

