import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/movie_entity.dart';
import '../providers/movies_provider.dart';
import '../../../../features/tasks/screens/movie_review_screen.dart';
import '../../../../features/tasks/models/movie.dart' as old;

/// Movie detail page
class MovieDetailPage extends ConsumerWidget {
  final MovieEntity movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              movie.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(movie.genre)),
                const SizedBox(width: 8),
                Text('${movie.year}'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 8),
                Text('${movie.rating}/10'),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              movie.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(moviesProvider.notifier).toggleWatched(movie.id);
                    },
                    icon: Icon(movie.isWatched ? Icons.check : Icons.check_box_outline_blank),
                    label: Text(movie.isWatched ? 'Просмотрен' : 'Отметить как просмотренный'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Convert MovieEntity to old Movie model for compatibility
                  final oldMovie = old.Movie(
                    id: movie.id,
                    title: movie.title,
                    description: movie.description,
                    genre: movie.genre,
                    year: movie.year,
                    rating: movie.rating,
                    isWatched: movie.isWatched,
                    createdAt: movie.createdAt,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieReviewScreen(movie: oldMovie),
                    ),
                  );
                },
                icon: const Icon(Icons.reviews),
                label: const Text('Посмотреть отзывы'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

