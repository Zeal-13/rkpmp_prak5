import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool notificationsEnabled;
  final bool isDarkTheme;
  final Function({bool? notifications, bool? darkTheme}) onUpdateSettings;

  const SettingsScreen({
    super.key,
    required this.notificationsEnabled,
    required this.isDarkTheme,
    required this.onUpdateSettings,
  });

  @override
  Widget build(BuildContext context) {
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
              value: notificationsEnabled,
              onChanged: (value) {
                onUpdateSettings(notifications: value);
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
              value: isDarkTheme,
              onChanged: (value) {
                onUpdateSettings(darkTheme: value);
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
                ListTile(
                  title: const Text('Версия приложения'),
                  subtitle: const Text('1.0.0'),
                  leading: const Icon(Icons.info),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Политика конфиденциальности'),
                  leading: const Icon(Icons.privacy_tip),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Условия использования'),
                  leading: const Icon(Icons.description),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Обратная связь'),
                  leading: const Icon(Icons.feedback),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
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
