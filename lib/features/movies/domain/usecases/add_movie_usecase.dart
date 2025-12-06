import '../entities/movie_entity.dart';
import '../repositories/movies_repository.dart';

/// Use case: Add a new movie
class AddMovieUseCase {
  final MoviesRepository repository;

  AddMovieUseCase(this.repository);

  Future<void> call(MovieEntity movie) async {
    // Business logic validation can be added here
    if (movie.title.isEmpty) {
      throw ArgumentError('Movie title cannot be empty');
    }
    if (movie.year < 1900 || movie.year > DateTime.now().year + 1) {
      throw ArgumentError('Invalid movie year');
    }
    
    await repository.addMovie(movie);
  }
}

