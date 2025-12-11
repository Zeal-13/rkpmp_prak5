import '../entities/movie_entity.dart';
import '../repositories/movies_repository.dart';

/// Use case для получения популярных фильмов через TMDB API
class GetPopularMoviesUseCase {
  final MoviesRepository repository;

  GetPopularMoviesUseCase(this.repository);

  Future<List<MovieEntity>> call() async {
    return await repository.getPopularMovies();
  }
}

