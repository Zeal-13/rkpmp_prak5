import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../models/movie_model.dart';
import 'movies_local_data_source.dart';

/// Drift (SQL) implementation of MoviesLocalDataSource
class MoviesDriftDataSource implements MoviesLocalDataSource {
  final AppDatabase _database;

  MoviesDriftDataSource(this._database);

  @override
  Future<List<MovieModel>> getMovies() async {
    final movies = await _database.select(_database.movies).get();
    return movies.map((row) => _rowToModel(row)).toList();
  }

  @override
  Future<MovieModel?> getMovieById(String id) async {
    final query = _database.select(_database.movies)
      ..where((tbl) => tbl.id.equals(id));
    
    final movie = await query.getSingleOrNull();
    return movie != null ? _rowToModel(movie) : null;
  }

  @override
  Future<void> addMovie(MovieModel movie) async {
    await _database.into(_database.movies).insert(_modelToRow(movie));
  }

  @override
  Future<void> updateMovie(MovieModel movie) async {
    await (_database.update(_database.movies)
          ..where((tbl) => tbl.id.equals(movie.id)))
        .write(_modelToRow(movie));
  }

  @override
  Future<void> deleteMovie(String id) async {
    await (_database.delete(_database.movies)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  /// Convert Drift row to MovieModel (from Movy)
  MovieModel _rowToModel(Movy row) {
    return MovieModel(
      id: row.id,
      title: row.title,
      description: row.description,
      genre: row.genre,
      year: row.year,
      rating: row.rating,
      isWatched: row.isWatched,
      createdAt: row.createdAt,
    );
  }

  /// Convert MovieModel to Drift row
  MoviesCompanion _modelToRow(MovieModel model) {
    return MoviesCompanion(
      id: Value(model.id),
      title: Value(model.title),
      description: Value(model.description),
      genre: Value(model.genre),
      year: Value(model.year),
      rating: Value(model.rating),
      isWatched: Value(model.isWatched),
      createdAt: Value(model.createdAt),
    );
  }
}

