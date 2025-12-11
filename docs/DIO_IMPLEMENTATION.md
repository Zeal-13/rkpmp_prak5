# Реализация Dio и DTO

## Обзор

Приложение было переработано для использования **Dio** вместо `http` пакета и добавлена реализация **DTO (Data Transfer Objects)** для всех сетевых запросов.

## Реализованные компоненты

### 1. Dio Client (`lib/core/network/dio_client.dart`)

Базовый класс для работы с API через Dio:
- Поддержка GET, POST, PUT, DELETE запросов
- Автоматическая обработка ошибок через interceptors
- Настройка таймаутов и заголовков
- Централизованная обработка исключений

### 2. DTO (Data Transfer Objects)

Созданы DTO для всех API:

#### TMDB API DTO (`lib/core/network/dto/tmdb_dto.dart`)
- `TmdbSearchResponseDto` - ответ поиска фильмов
- `TmdbPopularResponseDto` - ответ популярных фильмов
- `TmdbMovieDto` - данные фильма
- `TmdbGenreDto` - данные жанра

#### ReqRes API DTO (`lib/core/network/dto/reqres_dto.dart`)
- `ReqResRegisterRequestDto` - запрос регистрации
- `ReqResRegisterResponseDto` - ответ регистрации
- `ReqResLoginRequestDto` - запрос входа
- `ReqResLoginResponseDto` - ответ входа

#### JSONPlaceholder API DTO (`lib/core/network/dto/jsonplaceholder_dto.dart`)
- `JsonPlaceholderPostDto` - данные поста
- `JsonPlaceholderCommentDto` - данные комментария

### 3. Обновленные Data Sources

#### MoviesRemoteDataSource
- Использует `DioClient` вместо `ApiClient`
- Использует DTO для парсинга ответов TMDB API
- Методы: `searchMovies()`, `getPopularMovies()`, `getMovieDetails()`

#### AuthRemoteDataSource
- Использует `DioClient` вместо `ApiClient`
- Использует DTO для запросов и ответов ReqRes API
- Методы: `register()`, `login()`

#### PostsRemoteDataSource (новый)
- Использует `DioClient` для работы с JSONPlaceholder API
- Использует DTO для парсинга ответов
- Методы: `getPosts()`, `getPostComments()`

## Сетевые запросы

Реализовано **6 сетевых запросов** из **3 различных API**:

### TMDB API (3 запроса)
1. **Поиск фильмов** (`/search/movie`) - GET
2. **Популярные фильмы** (`/movie/popular`) - GET
3. **Детали фильма** (`/movie/{movie_id}`) - GET

### ReqRes API (2 запроса)
4. **Регистрация** (`/register`) - POST
5. **Вход** (`/login`) - POST

### JSONPlaceholder API (2 запроса)
6. **Получить посты** (`/posts`) - GET
7. **Получить комментарии** (`/posts/{postId}/comments`) - GET

## Dependency Injection

В `lib/core/di/injection_container.dart` настроена инициализация Dio клиентов:

```dart
// TMDB API Client
sl.registerLazySingleton<DioClient>(
  () => DioClient(
    baseUrl: 'https://api.themoviedb.org/3',
    headers: {'Content-Type': 'application/json'},
  ),
  instanceName: 'tmdb',
);

// ReqRes API Client
sl.registerLazySingleton<DioClient>(
  () => DioClient(
    baseUrl: 'https://reqres.in/api',
    headers: {'Content-Type': 'application/json'},
  ),
  instanceName: 'reqres',
);

// JSONPlaceholder API Client
sl.registerLazySingleton<DioClient>(
  () => DioClient(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    headers: {'Content-Type': 'application/json'},
  ),
  instanceName: 'jsonplaceholder',
);
```

Каждый data source получает соответствующий DioClient через DI.

## Структура файлов

```
lib/
├── core/
│   ├── network/
│   │   ├── dio_client.dart          # Базовый Dio клиент
│   │   ├── api_exception.dart       # Исключения для API
│   │   ├── api_client.dart          # Устаревший (для совместимости)
│   │   └── dto/
│   │       ├── tmdb_dto.dart        # DTO для TMDB API
│   │       ├── reqres_dto.dart      # DTO для ReqRes API
│   │       └── jsonplaceholder_dto.dart  # DTO для JSONPlaceholder API
│   └── di/
│       └── injection_container.dart # DI конфигурация
│
├── features/
│   ├── movies/
│   │   └── data/
│   │       └── datasources/
│   │           └── movies_remote_data_source.dart
│   ├── auth/
│   │   └── data/
│   │       └── datasources/
│   │           └── auth_remote_data_source.dart
│   └── posts/
│       └── data/
│           └── datasources/
│               └── posts_remote_data_source.dart
```

## Преимущества использования Dio

1. **Interceptors** - автоматическая обработка ошибок и логирование
2. **Типизация** - лучшая поддержка типов данных
3. **Отмена запросов** - возможность отмены запросов
4. **Трансформация данных** - встроенная поддержка трансформации ответов
5. **Плагины** - расширяемость через плагины

## Преимущества использования DTO

1. **Типобезопасность** - строгая типизация данных от API
2. **Валидация** - проверка данных на этапе парсинга
3. **Документация** - явная структура данных
4. **Переиспользование** - единые модели для запросов и ответов
5. **Тестируемость** - легко создавать моки для тестов

## Зависимости

Добавлен пакет `dio: ^5.4.0` в `pubspec.yaml`.

## Миграция

Старый `ApiClient` помечен как `@Deprecated` для обратной совместимости, но все новые реализации используют `DioClient`.

