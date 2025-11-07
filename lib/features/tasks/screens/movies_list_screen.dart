import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'movie_detail_screen.dart';
import 'movie_categories_screen.dart';
import 'add_movie_screen.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const MovieCategoriesScreen(),
                isScrollControlled: true,
              );
            },
          ),
        ],
      ),
      body: movies.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Нет добавленных фильмов',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: movie.isWatched ? Colors.green : Colors.grey,
                child: Icon(
                  movie.isWatched ? Icons.check : Icons.movie,
                  color: Colors.white,
                ),
              ),
              title: Text(movie.title),
              subtitle: Text('${movie.genre} • ${movie.year}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // ГОРИЗОНТАЛЬНАЯ НАВИГАЦИЯ - обычный Navigator.push
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMovieScreen(
                onAddMovie: ({
                  required String title,
                  required String description,
                  required String genre,
                  required int year,
                  required double rating,
                }) {
                  onAddMovie();
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
