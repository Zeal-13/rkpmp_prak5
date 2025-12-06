import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movies_list_page.dart';
import '../../../auth/presentation/pages/profile_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

/// Main tab container with bottom navigation
class MainTabContainer extends ConsumerStatefulWidget {
  const MainTabContainer({super.key});

  @override
  ConsumerState<MainTabContainer> createState() => _MainTabContainerState();
}

class _MainTabContainerState extends ConsumerState<MainTabContainer> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: const [
          MoviesListPage(),
          ProfilePage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Фильмы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}

