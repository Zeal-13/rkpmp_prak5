/// Export Drift implementation
library;
export 'movies_drift_data_source.dart' show MoviesDriftDataSource;

import '../models/movie_model.dart';

/// Local data source for movies
/// Abstract interface for movie storage
abstract class MoviesLocalDataSource {
  Future<List<MovieModel>> getMovies();
  Future<MovieModel?> getMovieById(String id);
  Future<void> addMovie(MovieModel movie);
  Future<void> updateMovie(MovieModel movie);
  Future<void> deleteMovie(String id);
}

