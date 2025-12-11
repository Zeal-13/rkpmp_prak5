import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dto/tmdb_dto.dart';
import '../../../../core/network/api_exception.dart';
import '../models/movie_model.dart';

/// Remote data source для работы с TMDB API
/// API: https://www.themoviedb.org/
abstract class MoviesRemoteDataSource {
  /// Поиск фильмов по запросу
  Future<List<MovieModel>> searchMovies(String query);

  /// Получить популярные фильмы
  Future<List<MovieModel>> getPopularMovies();

  /// Получить детали фильма по ID
  Future<MovieModel> getMovieDetails(int movieId);
}

/// Реализация MoviesRemoteDataSource с использованием TMDB API и Dio
class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final DioClient dioClient;
  
  // Используем бесплатный API ключ для демонстрации
  // В реальном приложении ключ должен храниться в переменных окружения
  static const String _apiKey = '1f54bd990f1cdfb230adb312546d765d';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  MoviesRemoteDataSourceImpl({DioClient? client})
      : dioClient = client ??
            DioClient(
              baseUrl: _baseUrl,
              headers: {'Content-Type': 'application/json'},
            );

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await dioClient.get(
        '/search/movie',
        queryParameters: {
          'api_key': _apiKey,
          'query': query,
          'language': 'ru-RU',
        },
      );

      // Используем DTO для парсинга ответа
      final dto = TmdbSearchResponseDto.fromJson(response);
      return dto.results.map((movieDto) => _mapDtoToMovieModel(movieDto)).toList();
    } on ApiException catch (e) {
      throw Exception('Ошибка при поиске фильмов: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при поиске фильмов: $e');
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final response = await dioClient.get(
        '/movie/popular',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'ru-RU',
          'page': '1',
        },
      );

      // Используем DTO для парсинга ответа
      final dto = TmdbPopularResponseDto.fromJson(response);
      return dto.results.map((movieDto) => _mapDtoToMovieModel(movieDto)).toList();
    } on ApiException catch (e) {
      throw Exception('Ошибка при получении популярных фильмов: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при получении популярных фильмов: $e');
    }
  }

  @override
  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final response = await dioClient.get(
        '/movie/$movieId',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'ru-RU',
        },
      );

      // Используем DTO для парсинга ответа
      final dto = TmdbMovieDto.fromJson(response);
      return _mapDtoToMovieModel(dto);
    } on ApiException catch (e) {
      throw Exception('Ошибка при получении деталей фильма: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при получении деталей фильма: $e');
    }
  }

  /// Преобразование DTO в MovieModel
  MovieModel _mapDtoToMovieModel(TmdbMovieDto dto) {
    // Получаем жанр из массива жанров
    final genre = dto.genres?.isNotEmpty == true
        ? dto.genres!.first.name
        : 'Неизвестно';

    // Получаем описание
    final overview = dto.overview ?? 'Описание отсутствует';

    return MovieModel(
      id: dto.id.toString(),
      title: dto.title,
      description: overview,
      genre: genre,
      year: _extractYear(dto.releaseDate),
      rating: dto.voteAverage ?? 0.0,
      isWatched: false,
      createdAt: DateTime.now(),
    );
  }

  /// Извлечь год из даты
  int _extractYear(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now().year;
    }
    try {
      final year = int.parse(dateString.split('-').first);
      return year;
    } catch (e) {
      return DateTime.now().year;
    }
  }
}

