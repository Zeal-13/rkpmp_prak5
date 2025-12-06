import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/get_movies_usecase.dart';
import '../../domain/usecases/add_movie_usecase.dart';
import '../../domain/usecases/delete_movie_usecase.dart';
import '../../domain/usecases/toggle_watched_usecase.dart';
import '../../../../core/di/injection_container.dart';

/// Movies state model
class MoviesState {
  final List<MovieEntity> movies;
  final bool isLoading;
  final String? error;

  MoviesState({
    required this.movies,
    this.isLoading = false,
    this.error,
  });

  MoviesState copyWith({
    List<MovieEntity>? movies,
    bool? isLoading,
    String? error,
  }) {
    return MoviesState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Movies state notifier
class MoviesNotifier extends StateNotifier<MoviesState> {
  final GetMoviesUseCase getMoviesUseCase;
  final AddMovieUseCase addMovieUseCase;
  final DeleteMovieUseCase deleteMovieUseCase;
  final ToggleWatchedUseCase toggleWatchedUseCase;

  MoviesNotifier({
    required this.getMoviesUseCase,
    required this.addMovieUseCase,
    required this.deleteMovieUseCase,
    required this.toggleWatchedUseCase,
  }) : super(MoviesState(movies: [])) {
    loadMovies();
  }

  Future<void> loadMovies() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final movies = await getMoviesUseCase();
      state = state.copyWith(movies: movies, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addMovie(MovieEntity movie) async {
    try {
      await addMovieUseCase(movie);
      await loadMovies();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteMovie(String movieId) async {
    try {
      await deleteMovieUseCase(movieId);
      await loadMovies();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> toggleWatched(String movieId) async {
    try {
      await toggleWatchedUseCase(movieId);
      await loadMovies();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Movies provider
final moviesProvider = StateNotifierProvider<MoviesNotifier, MoviesState>((ref) {
  return MoviesNotifier(
    getMoviesUseCase: sl<GetMoviesUseCase>(),
    addMovieUseCase: sl<AddMovieUseCase>(),
    deleteMovieUseCase: sl<DeleteMovieUseCase>(),
    toggleWatchedUseCase: sl<ToggleWatchedUseCase>(),
  );
});

