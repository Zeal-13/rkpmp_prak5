# Реализация множественных локальных хранилищ

## Обзор

Приложение использует два типа локальных хранилищ:
1. **Drift (SQL)** - для фильмов и пользователей
2. **SharedPreferences** - для настроек приложения

---

## Архитектура хранилищ

### 1. Drift (SQL) - Для структурированных данных

**Используется для:**
- ✅ Фильмы (Movies)
- ✅ Пользователи (Users)

**Преимущества:**
- Типобезопасные запросы
- Поддержка сложных SQL запросов
- Реляционные связи между таблицами
- Автоматическая генерация кода

### 2. SharedPreferences - Для простых настроек

**Используется для:**
- ✅ Настройки уведомлений
- ✅ Темная тема
- ✅ Запомнить меня

**Преимущества:**
- Простота использования
- Подходит для ключ-значение пар
- Быстрый доступ к данным

---

## Структура Drift базы данных

### Схема базы данных

```dart
// lib/core/database/database.dart
@DriftDatabase(tables: [Movies, Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}
```

### Таблица Movies

```dart
// lib/core/database/tables/movies_table.dart
class Movies extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get genre => text()();
  IntColumn get year => integer()();
  RealColumn get rating => real()();
  BoolColumn get isWatched => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Таблица Users

```dart
// lib/core/database/tables/users_table.dart
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

---

## Реализация Data Sources

### 1. Movies Data Source (Drift)

```dart
// lib/features/movies/data/datasources/movies_drift_data_source.dart
class MoviesDriftDataSource implements MoviesLocalDataSource {
  final AppDatabase _database;

  MoviesDriftDataSource(this._database);

  @override
  Future<List<MovieModel>> getMovies() async {
    final movies = await _database.select(_database.movies).get();
    return movies.map((row) => _rowToModel(row)).toList();
  }

  @override
  Future<void> addMovie(MovieModel movie) async {
    await _database.into(_database.movies).insert(_modelToRow(movie));
  }

  @override
  Future<void> updateMovie(MovieModel movie) async {
    await (_database.update(_database.movies)
          ..where((tbl) => tbl.id.equals(movie.id)))
        .write(_modelToRow(movie));
  }

  @override
  Future<void> deleteMovie(String id) async {
    await (_database.delete(_database.movies)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
```

**Примеры SQL запросов через Drift:**

```dart
// Получить все фильмы
final movies = await _database.select(_database.movies).get();

// Получить фильм по ID
final movie = await (_database.select(_database.movies)
  ..where((tbl) => tbl.id.equals(id)))
  .getSingleOrNull();

// Получить фильмы по жанру
final dramaMovies = await (_database.select(_database.movies)
  ..where((tbl) => tbl.genre.equals('Драма')))
  .get();

// Получить просмотренные фильмы
final watchedMovies = await (_database.select(_database.movies)
  ..where((tbl) => tbl.isWatched.equals(true)))
  .get();
```

### 2. Auth Data Source (Drift)

```dart
// lib/features/auth/data/datasources/auth_drift_data_source.dart
class AuthDriftDataSource implements AuthLocalDataSource {
  final AppDatabase _database;

  @override
  Future<UserModel?> getCurrentUser() async {
    final users = await _database.select(_database.users).get();
    if (users.isEmpty) return null;
    
    // Get the most recent user
    final userData = users.reduce((a, b) => 
      a.createdAt.isAfter(b.createdAt) ? a : b
    );
    
    return _rowToModel(userData);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    // Delete existing users (only one session at a time)
    await _database.delete(_database.users).go();
    await _database.into(_database.users).insert(_modelToRow(user));
  }

  @override
  Future<void> clearUser() async {
    await _database.delete(_database.users).go();
  }
}
```

### 3. Settings Data Source (SharedPreferences)

```dart
// lib/features/settings/data/datasources/settings_local_data_source.dart
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences _prefs;

  SettingsLocalDataSourceImpl(this._prefs);

  @override
  Future<bool> getNotificationsEnabled() async {
    return _prefs.getBool('notifications_enabled') ?? true;
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('notifications_enabled', enabled);
  }

  @override
  Future<bool> getDarkTheme() async {
    return _prefs.getBool('dark_theme') ?? false;
  }

  @override
  Future<void> setDarkTheme(bool enabled) async {
    await _prefs.setBool('dark_theme', enabled);
  }
}
```

---

## Dependency Injection

### Регистрация хранилищ

```dart
// lib/core/di/injection_container.dart
Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //! Database (Drift SQL)
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  //! Features - Auth (using Drift)
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthDriftDataSource(sl<AppDatabase>()),
  );

  //! Features - Movies (using Drift)
  sl.registerLazySingleton<MoviesLocalDataSource>(
    () => MoviesDriftDataSource(sl<AppDatabase>()),
  );

  //! Features - Settings (using SharedPreferences)
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sl()),
  );
}
```

---

## Преобразование данных

### Drift Row → Domain Model

```dart
// Movies
MovieModel _rowToModel(MoviesData row) {
  return MovieModel(
    id: row.id,
    title: row.title,
    description: row.description,
    genre: row.genre,
    year: row.year,
    rating: row.rating,
    isWatched: row.isWatched,
    createdAt: row.createdAt,
  );
}

// Users
UserModel _rowToModel(UsersData row) {
  return UserModel(
    id: row.id,
    email: row.email,
    name: row.name,
    createdAt: row.createdAt,
  );
}
```

### Domain Model → Drift Row

```dart
// Movies
MoviesCompanion _modelToRow(MovieModel model) {
  return MoviesCompanion(
    id: Value(model.id),
    title: Value(model.title),
    description: Value(model.description),
    genre: Value(model.genre),
    year: Value(model.year),
    rating: Value(model.rating),
    isWatched: Value(model.isWatched),
    createdAt: Value(model.createdAt),
  );
}
```

---

## Расположение файлов базы данных

### SQLite файл (Drift)

```
App Documents Directory/
  └── app_database.sqlite
```

**Путь на разных платформах:**
- **Android**: `/data/data/<package_name>/app_flutter/app_database.sqlite`
- **iOS**: `Documents/app_database.sqlite`
- **Windows**: `%LOCALAPPDATA%/flutter5/app_database.sqlite`

### SharedPreferences

Хранится в системном хранилище платформы:
- **Android**: SharedPreferences (XML файлы)
- **iOS**: UserDefaults
- **Windows**: Registry

---

## Примеры использования

### Добавление фильма (Drift)

```dart
// 1. Создание MovieModel
final movie = MovieModel(
  id: '123',
  title: 'The Matrix',
  description: 'Sci-fi movie',
  genre: 'Фантастика',
  year: 1999,
  rating: 9.5,
  isWatched: false,
  createdAt: DateTime.now(),
);

// 2. Сохранение через Data Source
await moviesDataSource.addMovie(movie);

// 3. Drift автоматически выполняет SQL INSERT
// INSERT INTO movies (id, title, description, ...) VALUES (...)
```

### Получение настроек (SharedPreferences)

```dart
// 1. Получение через Data Source
final notificationsEnabled = await settingsDataSource.getNotificationsEnabled();

// 2. SharedPreferences выполняет:
// _prefs.getBool('notifications_enabled')
```

---

## Миграции базы данных

### Пример миграции при изменении схемы

```dart
@override
int get schemaVersion => 2; // Увеличить версию

@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Добавить новую колонку
        await m.addColumn(movies, movies.newColumn);
      }
    },
  );
}
```

---

## Преимущества использования двух хранилищ

### Drift для фильмов и пользователей:

✅ **Структурированные данные**: Сложные объекты с множеством полей
✅ **SQL запросы**: Фильтрация, сортировка, поиск
✅ **Реляционные связи**: Возможность связывать таблицы в будущем
✅ **Типобезопасность**: Автоматическая генерация кода

### SharedPreferences для настроек:

✅ **Простота**: Ключ-значение пары
✅ **Быстрый доступ**: Нет необходимости в сложных запросах
✅ **Легкий код**: Минимум boilerplate

---

## Сравнение хранилищ

| Характеристика | Drift (SQL) | SharedPreferences |
|----------------|-------------|-------------------|
| **Тип данных** | Структурированные объекты | Простые типы (bool, String, int) |
| **Запросы** | SQL запросы, JOIN, WHERE | Простое чтение/запись |
| **Производительность** | Высокая для больших объемов | Очень высокая для малых данных |
| **Сложность** | Средняя | Низкая |
| **Использование** | Movies, Users | Settings |

---

## Команды для генерации кода

После изменения таблиц Drift необходимо сгенерировать код:

```bash
# Генерация кода Drift
flutter pub run build_runner build --delete-conflicting-outputs

# Или в watch режиме (автоматическая генерация)
flutter pub run build_runner watch
```

---

## Итоговая структура хранилищ

```
┌─────────────────────────────────────────┐
│         Application Layer               │
│  (Use Cases, Providers, UI)             │
└──────────────┬──────────────────────────┘
               │
       ┌───────┴────────┐
       │                │
┌──────▼──────┐  ┌──────▼──────────────┐
│   Drift     │  │ SharedPreferences   │
│   (SQL)     │  │   (Key-Value)       │
├─────────────┤  ├─────────────────────┤
│ • Movies    │  │ • Notifications     │
│ • Users     │  │ • Dark Theme        │
│             │  │ • Remember Me       │
└─────────────┘  └─────────────────────┘
       │                │
       └────────┬───────┘
                │
       ┌────────▼────────┐
       │  SQLite DB File │
       │  (app_database) │
       └─────────────────┘
```

---

## Резюме

Приложение использует гибридный подход к хранению данных:

1. **Drift (SQL)** для фильмов и пользователей - структурированные данные с возможностью сложных запросов
2. **SharedPreferences** для настроек - простые ключ-значение пары

Это обеспечивает оптимальное использование ресурсов и простоту кода в зависимости от типа данных.

