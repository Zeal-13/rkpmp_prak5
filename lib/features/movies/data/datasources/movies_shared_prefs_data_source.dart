import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/movie_model.dart';
import 'movies_local_data_source.dart';

/// SharedPreferences implementation of MoviesLocalDataSource для веб
class MoviesSharedPrefsDataSource implements MoviesLocalDataSource {
  final SharedPreferences _prefs;
  static const String _moviesKey = 'movies_list';

  MoviesSharedPrefsDataSource(this._prefs);

  @override
  Future<List<MovieModel>> getMovies() async {
    final moviesJson = _prefs.getString(_moviesKey);
    if (moviesJson == null) {
      return [];
    }
    try {
      final List<dynamic> jsonList = jsonDecode(moviesJson) as List<dynamic>;
      return jsonList
          .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<MovieModel?> getMovieById(String id) async {
    final movies = await getMovies();
    try {
      return movies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addMovie(MovieModel movie) async {
    final movies = await getMovies();
    movies.add(movie);
    await _saveMovies(movies);
  }

  @override
  Future<void> updateMovie(MovieModel movie) async {
    final movies = await getMovies();
    final index = movies.indexWhere((m) => m.id == movie.id);
    if (index != -1) {
      movies[index] = movie;
      await _saveMovies(movies);
    }
  }

  @override
  Future<void> deleteMovie(String id) async {
    final movies = await getMovies();
    movies.removeWhere((movie) => movie.id == id);
    await _saveMovies(movies);
  }

  Future<void> _saveMovies(List<MovieModel> movies) async {
    final moviesJson = jsonEncode(
      movies.map((movie) => movie.toJson()).toList(),
    );
    await _prefs.setString(_moviesKey, moviesJson);
  }
}


