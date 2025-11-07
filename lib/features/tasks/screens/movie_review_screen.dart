import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieReviewScreen extends StatelessWidget {
  final Movie movie;

  const MovieReviewScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отзывы: ${movie.title}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(child: Text('U${index + 1}')),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Пользователь ${index + 1}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: List.generate(
                              5,
                                  (i) => Icon(Icons.star,
                                  size: 16,
                                  color:
                                  i < (4 - index % 2) ? Colors.amber : Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Отличный фильм! Рекомендую всем к просмотру.'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
