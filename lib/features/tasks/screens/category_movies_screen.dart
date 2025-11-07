import 'package:flutter/material.dart';

class CategoryMoviesScreen extends StatelessWidget {
  final String categoryName;

  const CategoryMoviesScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Фильмы: $categoryName'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 75,
                color: Colors.grey[300],
                child: const Icon(Icons.movie),
              ),
              title: Text('$categoryName фильм ${index + 1}'),
              subtitle: Text('Год: ${2020 + index}'),
              trailing: const Text('8.5 ⭐'),
            ),
          );
        },
      ),
    );
  }
}
