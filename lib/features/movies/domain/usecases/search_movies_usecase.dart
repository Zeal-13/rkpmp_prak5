import '../entities/movie_entity.dart';
import '../repositories/movies_repository.dart';

/// Use case для поиска фильмов через TMDB API
class SearchMoviesUseCase {
  final MoviesRepository repository;

  SearchMoviesUseCase(this.repository);

  Future<List<MovieEntity>> call(String query) async {
    return await repository.searchMovies(query);
  }
}

