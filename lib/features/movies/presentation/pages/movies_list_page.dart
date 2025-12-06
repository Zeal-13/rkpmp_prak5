import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/movies_provider.dart';
import 'add_movie_page.dart';
import 'movie_detail_page.dart';
import '../../../../features/tasks/screens/movie_categories_screen.dart';

/// Movies list page
class MoviesListPage extends ConsumerWidget {
  const MoviesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesState = ref.watch(moviesProvider);

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
      body: moviesState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : moviesState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ошибка: ${moviesState.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(moviesProvider.notifier).loadMovies();
                        },
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                )
              : moviesState.movies.isEmpty
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
                      itemCount: moviesState.movies.length,
                      itemBuilder: (context, index) {
                        final movie = moviesState.movies[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  movie.isWatched ? Colors.green : Colors.grey,
                              child: Icon(
                                movie.isWatched ? Icons.check : Icons.movie,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(movie.title),
                            subtitle: Text('${movie.genre} • ${movie.year}'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailPage(
                                    movie: movie,
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Удалить фильм?'),
                                  content: Text('Вы уверены, что хотите удалить "${movie.title}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Отмена'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ref
                                            .read(moviesProvider.notifier)
                                            .deleteMovie(movie.id);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Удалить', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
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
              builder: (context) => const AddMoviePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

