import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movies_local_data_source.dart';
import '../datasources/movies_remote_data_source.dart';
import '../models/movie_model.dart';

/// Implementation of MoviesRepository
/// Bridges domain layer with data layer
/// Uses both remote (API) and local (database) data sources
class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesLocalDataSource localDataSource;
  final MoviesRemoteDataSource remoteDataSource;

  MoviesRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<List<MovieEntity>> getMovies() async {
    final models = await localDataSource.getMovies();
    return models;
  }

  @override
  Future<MovieEntity?> getMovieById(String id) async {
    final model = await localDataSource.getMovieById(id);
    return model;
  }

  @override
  Future<void> addMovie(MovieEntity movie) async {
    final model = MovieModel.fromEntity(movie);
    await localDataSource.addMovie(model);
  }

  @override
  Future<void> updateMovie(MovieEntity movie) async {
    final model = MovieModel.fromEntity(movie);
    await localDataSource.updateMovie(model);
  }

  @override
  Future<void> deleteMovie(String id) async {
    await localDataSource.deleteMovie(id);
  }

  @override
  Future<void> toggleWatched(String id) async {
    final movie = await localDataSource.getMovieById(id);
    if (movie != null) {
      final updated = movie.copyWith(isWatched: !movie.isWatched);
      await localDataSource.updateMovie(updated);
    }
  }

  @override
  Future<List<MovieEntity>> searchMovies(String query) async {
    try {
      final movies = await remoteDataSource.searchMovies(query);
      return movies;
    } catch (e) {
      throw Exception('Ошибка при поиске фильмов: $e');
    }
  }

  @override
  Future<List<MovieEntity>> getPopularMovies() async {
    try {
      final movies = await remoteDataSource.getPopularMovies();
      return movies;
    } catch (e) {
      throw Exception('Ошибка при получении популярных фильмов: $e');
    }
  }

  @override
  Future<MovieEntity> getMovieDetails(int movieId) async {
    try {
      final movie = await remoteDataSource.getMovieDetails(movieId);
      return movie;
    } catch (e) {
      throw Exception('Ошибка при получении деталей фильма: $e');
    }
  }
}

