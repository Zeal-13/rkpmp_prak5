# Clean Architecture Implementation

## Обзор

Приложение было переработано согласно принципам Clean Architecture. Архитектура разделена на три основных слоя:

## Структура проекта

```
lib/
├── core/                          # Общие компоненты
│   └── di/
│       └── injection_container.dart   # Dependency Injection (GetIt)
│
├── features/                      # Функциональные модули
│   ├── app/                      # Главный модуль приложения
│   │   └── presentation/
│   │       └── pages/
│   │           └── app_container.dart
│   │
│   ├── auth/                     # Модуль аутентификации
│   │   ├── domain/               # Domain Layer
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── register_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       └── get_current_user_usecase.dart
│   │   ├── data/                 # Data Layer
│   │   │   ├── datasources/
│   │   │   │   └── auth_local_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   └── presentation/         # Presentation Layer
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       └── pages/
│   │           ├── auth_page.dart
│   │           ├── register_page.dart
│   │           └── profile_page.dart
│   │
│   ├── movies/                   # Модуль фильмов
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── movie_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── movies_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_movies_usecase.dart
│   │   │       ├── add_movie_usecase.dart
│   │   │       ├── delete_movie_usecase.dart
│   │   │       └── toggle_watched_usecase.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── movies_local_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── movie_model.dart
│   │   │   └── repositories/
│   │   │       └── movies_repository_impl.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── movies_provider.dart
│   │       └── pages/
│   │           ├── movies_list_page.dart
│   │           ├── add_movie_page.dart
│   │           ├── movie_detail_page.dart
│   │           └── main_tab_container.dart
│   │
│   └── settings/                 # Модуль настроек
│       ├── domain/
│       │   ├── repositories/
│       │   │   └── settings_repository.dart
│       │   └── usecases/
│       │       ├── get_settings_usecase.dart
│       │       └── update_settings_usecase.dart
│       ├── data/
│       │   ├── datasources/
│       │   │   └── settings_local_data_source.dart
│       │   └── repositories/
│       │       └── settings_repository_impl.dart
│       └── presentation/
│           ├── providers/
│           │   └── settings_provider.dart
│           └── pages/
│               └── settings_page.dart
│
├── shared/                       # Общие ресурсы
│   └── app_theme.dart
│
├── main.dart                     # Точка входа
└── app.dart                      # Главный виджет приложения
```

## Слои архитектуры

### 1. Domain Layer (Бизнес-логика)

**Ответственность:**
- Содержит бизнес-логику приложения
- Независим от фреймворков и внешних библиотек
- Определяет интерфейсы репозиториев
- Содержит Use Cases (use cases)

**Компоненты:**
- **Entities**: Бизнес-модели (MovieEntity, UserEntity)
- **Repositories (интерфейсы)**: Контракты для работы с данными
- **Use Cases**: Бизнес-операции

**Зависимости:** Нет зависимостей от других слоев

### 2. Data Layer (Работа с данными)

**Ответственность:**
- Реализация репозиториев
- Работа с источниками данных (локальное хранилище, API)
- Преобразование моделей данных в доменные сущности

**Компоненты:**
- **Data Sources**: Локальное хранилище, API клиенты
- **Models**: Модели данных с сериализацией
- **Repository Implementations**: Реализация интерфейсов из Domain Layer

**Зависимости:** Domain Layer

### 3. Presentation Layer (UI)

**Ответственность:**
- Отображение пользовательского интерфейса
- Управление состоянием (Riverpod)
- Навигация

**Компоненты:**
- **Pages/Screens**: UI виджеты
- **Providers**: State management (Riverpod)
- **Widgets**: Переиспользуемые компоненты UI

**Зависимости:** Domain Layer, Data Layer (через DI)

## Принципы Clean Architecture

### 1. Dependency Rule
Зависимости направлены внутрь: Presentation → Domain ← Data

### 2. Separation of Concerns
Каждый слой имеет четко определенную ответственность

### 3. Testability
- Domain Layer легко тестируется (нет зависимостей)
- Data Layer можно мокировать через интерфейсы
- Presentation Layer тестируется через unit/widget тесты

### 4. Independence
- Domain Layer не зависит от Flutter
- Можно легко заменить UI или источник данных

## Используемые технологии

- **State Management**: Flutter Riverpod
- **Dependency Injection**: GetIt
- **Local Storage**: SharedPreferences (для настроек), in-memory (для фильмов)
- **Architecture**: Clean Architecture

## Пример потока данных

```
UI (MoviesListPage)
  ↓
Provider (MoviesNotifier)
  ↓
Use Case (GetMoviesUseCase)
  ↓
Repository Interface (MoviesRepository)
  ↓
Repository Implementation (MoviesRepositoryImpl)
  ↓
Data Source (MoviesLocalDataSource)
  ↓
Data Storage (in-memory / SharedPreferences / API)
```

## Инициализация

Dependency Injection настраивается в `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Инициализация GetIt контейнера
  runApp(const MyApp());
}
```

## Преимущества архитектуры

1. **Тестируемость**: Каждый слой можно тестировать независимо
2. **Масштабируемость**: Легко добавлять новые функции
3. **Поддерживаемость**: Четкое разделение ответственности
4. **Гибкость**: Можно менять UI или источники данных без изменения бизнес-логики
5. **Читаемость**: Понятная структура проекта

