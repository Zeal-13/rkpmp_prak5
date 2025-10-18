import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final Function(String movieId) onToggleWatched;
  final Function(String movieId) onDelete;

  const MovieTile({
    super.key,
    required this.movie,
    required this.onToggleWatched,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(movie.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        onDelete(movie.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: movie.isWatched ? Colors.green : Colors.grey,
            child: Icon(
              movie.isWatched ? Icons.check : Icons.movie,
              color: Colors.white,
            ),
          ),
          title: Text(
            movie.title,
            style: TextStyle(
              decoration: movie.isWatched ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${movie.genre} • ${movie.year}'),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text('${movie.rating}'),
                ],
              ),
            ],
          ),
          trailing: Checkbox(
            value: movie.isWatched,
            onChanged: (value) {
              onToggleWatched(movie.id);
            },
          ),
          onTap: () {
            // Здесь можно реализовать детальный просмотр фильма
          },
        ),
      ),
    );
  }
}
