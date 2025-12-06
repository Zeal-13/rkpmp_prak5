import '../repositories/movies_repository.dart';

/// Use case: Toggle watched status of a movie
class ToggleWatchedUseCase {
  final MoviesRepository repository;

  ToggleWatchedUseCase(this.repository);

  Future<void> call(String movieId) async {
    if (movieId.isEmpty) {
      throw ArgumentError('Movie ID cannot be empty');
    }
    
    await repository.toggleWatched(movieId);
  }
}

