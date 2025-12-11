import '../entities/movie_entity.dart';

/// Repository interface for Movies
/// Defines the contract for data operations without implementation details
abstract class MoviesRepository {
  /// Get all movies (from local storage)
  Future<List<MovieEntity>> getMovies();

  /// Get movie by ID (from local storage)
  Future<MovieEntity?> getMovieById(String id);

  /// Add a new movie (to local storage)
  Future<void> addMovie(MovieEntity movie);

  /// Update an existing movie (in local storage)
  Future<void> updateMovie(MovieEntity movie);

  /// Delete a movie (from local storage)
  Future<void> deleteMovie(String id);

  /// Toggle watched status (in local storage)
  Future<void> toggleWatched(String id);

  /// Search movies from TMDB API
  Future<List<MovieEntity>> searchMovies(String query);

  /// Get popular movies from TMDB API
  Future<List<MovieEntity>> getPopularMovies();

  /// Get movie details from TMDB API
  Future<MovieEntity> getMovieDetails(int movieId);
}

