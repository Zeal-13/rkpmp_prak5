import '../entities/movie_entity.dart';
import '../repositories/movies_repository.dart';

/// Use case для получения деталей фильма через TMDB API
class GetMovieDetailsUseCase {
  final MoviesRepository repository;

  GetMovieDetailsUseCase(this.repository);

  Future<MovieEntity> call(int movieId) async {
    return await repository.getMovieDetails(movieId);
  }
}

