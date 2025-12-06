import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movies_local_data_source.dart';
import '../models/movie_model.dart';

/// Implementation of MoviesRepository
/// Bridges domain layer with data layer
class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesLocalDataSource localDataSource;

  MoviesRepositoryImpl(this.localDataSource);

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
}

