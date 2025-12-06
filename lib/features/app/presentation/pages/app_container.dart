import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../../movies/presentation/pages/main_tab_container.dart';

/// Main app container that handles navigation based on auth state
class AppContainer extends ConsumerWidget {
  const AppContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Show loading while checking auth status
    if (authState.isLoading && authState.user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show auth screen if not authenticated
    if (!authState.isAuthenticated) {
      return const AuthPage();
    }

    // Show main app if authenticated
    return const MainTabContainer();
  }
}

