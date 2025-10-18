import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'movie_tile.dart';

class MoviesListView extends StatelessWidget {
  final List<Movie> movies;
  final Function(String movieId) onToggleWatched;
  final Function(String movieId) onDeleteMovie;

  const MoviesListView({
    super.key,
    required this.movies,
    required this.onToggleWatched,
    required this.onDeleteMovie,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieTile(
          key: ValueKey(movie.id),
          movie: movie,
          onToggleWatched: onToggleWatched,
          onDelete: onDeleteMovie,
        );
      },
    );
  }
}
