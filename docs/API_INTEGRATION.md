# Интеграция сетевых API

## Обзор

Приложение было переработано для работы с внешними API. Реализовано **4 сетевых запроса** из **2 различных API**.

## Используемые API

### 1. TMDB API (The Movie Database)
**Базовый URL:** `https://api.themoviedb.org/3`  
**Документация:** https://www.themoviedb.org/documentation/api

**Реализованные запросы:**
1. **Поиск фильмов** (`/search/movie`)
   - Метод: `GET`
   - Параметры: `query`, `api_key`, `language`
   - Использование: Поиск фильмов по названию

2. **Получение популярных фильмов** (`/movie/popular`)
   - Метод: `GET`
   - Параметры: `api_key`, `language`, `page`
   - Использование: Получение списка популярных фильмов

3. **Получение деталей фильма** (`/movie/{movie_id}`)
   - Метод: `GET`
   - Параметры: `api_key`, `language`
   - Использование: Получение подробной информации о фильме

### 2. ReqRes API
**Базовый URL:** `https://reqres.in/api`  
**Документация:** https://reqres.in/

**Реализованные запросы:**
4. **Вход пользователя** (`/login`)
   - Метод: `POST`
   - Тело запроса: `email`, `password`
   - Использование: Аутентификация пользователя

## Архитектура реализации

### Структура файлов

```
lib/
├── core/
│   └── network/
│       └── api_client.dart          # Базовый клиент для работы с API
│
├── features/
│   ├── movies/
│   │   └── data/
│   │       └── datasources/
│   │           └── movies_remote_data_source.dart  # TMDB API
│   │
│   └── auth/
│       └── data/
│           └── datasources/
│               └── auth_remote_data_source.dart     # ReqRes API
```

### Компоненты

#### 1. ApiClient (`lib/core/network/api_client.dart`)
Базовый класс для выполнения HTTP запросов:
- Поддержка GET и POST запросов
- Обработка ошибок
- Настройка заголовков

#### 2. MoviesRemoteDataSource
Реализация работы с TMDB API:
- `searchMovies(String query)` - поиск фильмов
- `getPopularMovies()` - популярные фильмы
- `getMovieDetails(int movieId)` - детали фильма

#### 3. AuthRemoteDataSource
Реализация работы с ReqRes API:
- `login()` - вход (регистрация выполняется локально без API)

### Интеграция с репозиториями

Репозитории используют гибридный подход:
- **Remote Data Source** - для получения данных из API
- **Local Data Source** - для кэширования и офлайн работы

Пример:
```dart
class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesLocalDataSource localDataSource;
  final MoviesRemoteDataSource remoteDataSource;

  @override
  Future<List<MovieEntity>> searchMovies(String query) async {
    // Сетевой запрос к TMDB API
    return await remoteDataSource.searchMovies(query);
  }
}
```

## Использование в приложении

### Пример использования через Use Cases

```dart
// Поиск фильмов
final searchUseCase = sl<SearchMoviesUseCase>();
final movies = await searchUseCase('Inception');

// Популярные фильмы
final popularUseCase = sl<GetPopularMoviesUseCase>();
final popularMovies = await popularUseCase();

// Детали фильма
final detailsUseCase = sl<GetMovieDetailsUseCase>();
final movie = await detailsUseCase(550);

// Регистрация (выполняется локально, без API)
final registerUseCase = sl<RegisterUseCase>();
final user = await registerUseCase(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
);

// Вход (через ReqRes API)
final loginUseCase = sl<LoginUseCase>();
final user = await loginUseCase('john@example.com', 'password123');
```

## Обработка ошибок

Все сетевые запросы обрабатывают ошибки через `ApiException`:
- HTTP статус коды
- Сообщения об ошибках
- Тело ответа при ошибке

## Зависимости

Добавлен пакет `http: ^1.1.0` для выполнения HTTP запросов.

## Примечания

- TMDB API ключ хранится в коде (для демонстрации). В продакшене следует использовать переменные окружения.
- ReqRes API - это тестовый API, не предназначенный для продакшена.
- Регистрация выполняется локально без API запросов.
- Все запросы выполняются асинхронно и возвращают Future.

