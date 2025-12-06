import '../entities/movie_entity.dart';

/// Repository interface for Movies
/// Defines the contract for data operations without implementation details
abstract class MoviesRepository {
  /// Get all movies
  Future<List<MovieEntity>> getMovies();

  /// Get movie by ID
  Future<MovieEntity?> getMovieById(String id);

  /// Add a new movie
  Future<void> addMovie(MovieEntity movie);

  /// Update an existing movie
  Future<void> updateMovie(MovieEntity movie);

  /// Delete a movie
  Future<void> deleteMovie(String id);

  /// Toggle watched status
  Future<void> toggleWatched(String id);
}

