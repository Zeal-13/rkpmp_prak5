import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';

class MoviesNotifier extends StateNotifier<List<Movie>> {
  MoviesNotifier() : super([]);

  void addMovie(Movie movie) {
    state = [...state, movie];
  }

  void toggleWatched(String movieId) {
    state = state.map((movie) {
      if (movie.id == movieId) {
        return movie.copyWith(isWatched: !movie.isWatched);
      }
      return movie;
    }).toList();
  }

  void deleteMovie(String movieId) {
    state = state.where((movie) => movie.id != movieId).toList();
  }

  void restoreMovie(Movie movie, int index) {
    final movies = List<Movie>.from(state);
    movies.insert(index, movie);
    state = movies;
  }
}

final moviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  return MoviesNotifier();
});

