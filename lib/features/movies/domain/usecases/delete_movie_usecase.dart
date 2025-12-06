import '../repositories/movies_repository.dart';

/// Use case: Delete a movie
class DeleteMovieUseCase {
  final MoviesRepository repository;

  DeleteMovieUseCase(this.repository);

  Future<void> call(String movieId) async {
    if (movieId.isEmpty) {
      throw ArgumentError('Movie ID cannot be empty');
    }
    
    await repository.deleteMovie(movieId);
  }
}

