import 'package:drift/drift.dart';

/// Создание базы данных для веб-платформы
/// Для веб используем простую реализацию в памяти
/// В продакшене можно использовать drift_web с IndexedDB
LazyDatabase createDatabase() {
  return LazyDatabase(() async {
    // Для веб-платформы база данных не поддерживается
    // Используем только сетевые запросы и SharedPreferences
    throw UnsupportedError(
      'Database не поддерживается на веб-платформе. '
      'Используйте только сетевые запросы или добавьте drift_web.',
    );
  });
}


