import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

enum AppScreen { auth, register, main }

class AppState {
  final AppScreen currentScreen;
  final User? currentUser;
  final int currentTabIndex;
  final bool rememberMe;
  final bool acceptTerms;

  AppState({
    this.currentScreen = AppScreen.auth,
    this.currentUser,
    this.currentTabIndex = 0,
    this.rememberMe = false,
    this.acceptTerms = false,
  });

  AppState copyWith({
    AppScreen? currentScreen,
    User? currentUser,
    int? currentTabIndex,
    bool? rememberMe,
    bool? acceptTerms,
  }) {
    return AppState(
      currentScreen: currentScreen ?? this.currentScreen,
      currentUser: currentUser ?? this.currentUser,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      rememberMe: rememberMe ?? this.rememberMe,
      acceptTerms: acceptTerms ?? this.acceptTerms,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState());

  void showAuthScreen() {
    state = state.copyWith(currentScreen: AppScreen.auth);
  }

  void showRegisterScreen() {
    state = state.copyWith(currentScreen: AppScreen.register);
  }

  void showMainScreen() {
    state = state.copyWith(currentScreen: AppScreen.main);
  }

  void login(User user, bool rememberMe) {
    state = state.copyWith(
      currentUser: user,
      rememberMe: rememberMe,
      currentScreen: AppScreen.main,
    );
  }

  void register(User user, bool acceptTerms) {
    state = state.copyWith(
      currentUser: user,
      acceptTerms: acceptTerms,
      currentScreen: AppScreen.main,
    );
  }

  void logout() {
    state = AppState(
      currentScreen: AppScreen.auth,
      currentTabIndex: 0,
    );
  }

  void setTabIndex(int index) {
    state = state.copyWith(currentTabIndex: index);
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

