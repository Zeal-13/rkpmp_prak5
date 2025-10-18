import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movies_list_view.dart';

class MoviesListScreen extends StatelessWidget {
  final List<Movie> movies;
  final VoidCallback onAddMovie;
  final Function(String movieId) onToggleWatched;
  final Function(String movieId) onDeleteMovie;

  const MoviesListScreen({
    super.key,
    required this.movies,
    required this.onAddMovie,
    required this.onToggleWatched,
    required this.onDeleteMovie,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои фильмы'),
      ),
      body: movies.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Нет добавленных фильмов',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Добавьте свой первый фильм!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
          : MoviesListView(
        movies: movies,
        onToggleWatched: onToggleWatched,
        onDeleteMovie: onDeleteMovie,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddMovie,
        child: const Icon(Icons.add),
      ),
    );
  }
}
