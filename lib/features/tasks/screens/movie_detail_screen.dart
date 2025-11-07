import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'movie_review_screen.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // ГОРИЗОНТАЛЬНАЯ НАВИГАЦИЯ
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieReviewScreen(movie: movie),
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
