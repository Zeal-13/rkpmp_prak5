import '../entities/movie_entity.dart';
import '../repositories/movies_repository.dart';

/// Use case: Get all movies
/// Encapsulates the business logic for retrieving movies
class GetMoviesUseCase {
  final MoviesRepository repository;

  GetMoviesUseCase(this.repository);

  Future<List<MovieEntity>> call() async {
    return await repository.getMovies();
  }
}

