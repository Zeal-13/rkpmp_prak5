import 'package:flutter/material.dart';
import 'app.dart';
import 'features/tasks/models/movie.dart';
import 'features/tasks/screens/add_movie_screen.dart';
import 'features/tasks/screens/category_movies_screen.dart';
import 'features/tasks/screens/movie_categories_screen.dart';
import 'features/tasks/screens/movie_detail_screen.dart';
import 'features/tasks/screens/movie_review_screen.dart';
import 'features/tasks/state/tasks_container.dart';

import 'package:flutter/material.dart';
import 'app.dart';
import 'features/tasks/models/movie.dart';
import 'features/tasks/screens/add_movie_screen.dart';

void main() {
  runApp(const MyApp());
}

class AccessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const TasksContainer(),
        '/movie_detail': (context) {
          final movie = ModalRoute.of(context)!.settings.arguments;
          return MovieDetailScreen(movie: movie as Movie);
        },
        '/movie_review': (context) {
          final movie = ModalRoute.of(context)!.settings.arguments;
          return MovieReviewScreen(movie: movie as Movie);
        },
        '/add_movie': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
          as Map<String, dynamic>?;
          return AddMovieScreen(
            onAddMovie: args?['onAddMovie'] ?? (Map<String, dynamic> data) {},
          );
        },
        '/categories': (context) => const MovieCategoriesScreen(),
        '/category_movies': (context) {
          final categoryName =
          ModalRoute.of(context)!.settings.arguments as String;
          return CategoryMoviesScreen(categoryName: categoryName);
        },
      },
      theme: ThemeData(primarySwatch: Colors.indigo),
    );
  }
}


