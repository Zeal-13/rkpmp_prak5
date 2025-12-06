import '../models/movie_model.dart';

/// Local data source for movies
/// Handles in-memory storage (can be replaced with SharedPreferences/Hive)
abstract class MoviesLocalDataSource {
  Future<List<MovieModel>> getMovies();
  Future<MovieModel?> getMovieById(String id);
  Future<void> addMovie(MovieModel movie);
  Future<void> updateMovie(MovieModel movie);
  Future<void> deleteMovie(String id);
}

/// In-memory implementation of MoviesLocalDataSource
class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  final List<MovieModel> _movies = [];

  @override
  Future<List<MovieModel>> getMovies() async {
    return List.from(_movies);
  }

  @override
  Future<MovieModel?> getMovieById(String id) async {
    try {
      return _movies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addMovie(MovieModel movie) async {
    _movies.add(movie);
  }

  @override
  Future<void> updateMovie(MovieModel movie) async {
    final index = _movies.indexWhere((m) => m.id == movie.id);
    if (index != -1) {
      _movies[index] = movie;
    }
  }

  @override
  Future<void> deleteMovie(String id) async {
    _movies.removeWhere((movie) => movie.id == id);
  }
}

