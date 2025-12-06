import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

/// Settings page
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Уведомления',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Включить уведомления'),
              subtitle: const Text('Получать уведомления о новых фильмах'),
              value: settingsState.notificationsEnabled,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).updateSettings(
                      notificationsEnabled: value,
                    );
              },
              secondary: const Icon(Icons.notifications),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Внешний вид',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Темная тема'),
              subtitle: const Text('Использовать темную тему'),
              value: settingsState.darkTheme,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).updateSettings(
                      darkTheme: value,
                    );
              },
              secondary: const Icon(Icons.dark_mode),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'О приложении',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text('Версия приложения'),
                  subtitle: Text('1.0.0'),
                  leading: Icon(Icons.info),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Политика конфиденциальности'),
                  leading: const Icon(Icons.privacy_tip),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to privacy policy
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Условия использования'),
                  leading: const Icon(Icons.description),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to terms
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Обратная связь'),
                  leading: const Icon(Icons.feedback),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to feedback
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

