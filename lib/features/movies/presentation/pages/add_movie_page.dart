import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/movies_provider.dart';
import '../../domain/entities/movie_entity.dart';

/// Add movie page
class AddMoviePage extends ConsumerStatefulWidget {
  const AddMoviePage({super.key});

  @override
  ConsumerState<AddMoviePage> createState() => _AddMoviePageState();
}

class _AddMoviePageState extends ConsumerState<AddMoviePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _yearController = TextEditingController();

  String _selectedGenre = 'Драма';
  double _rating = 7.0;

  final List<String> _genres = [
    'Драма',
    'Комедия',
    'Боевик',
    'Триллер',
    'Ужасы',
    'Фантастика',
    'Романтика',
    'Документальный',
    'Анимация',
    'Криминал',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _submitMovie() async {
    if (_formKey.currentState!.validate()) {
      final movie = MovieEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        genre: _selectedGenre,
        year: int.parse(_yearController.text),
        rating: _rating,
        isWatched: false,
        createdAt: DateTime.now(),
      );

      await ref.read(moviesProvider.notifier).addMovie(movie);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Фильм успешно добавлен!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить фильм'),
        actions: [
          TextButton(
            onPressed: _submitMovie,
            child: const Text(
              'Сохранить',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название фильма',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название фильма';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите описание фильма';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGenre,
                decoration: const InputDecoration(
                  labelText: 'Жанр',
                  border: OutlineInputBorder(),
                ),
                items: _genres.map((String genre) {
                  return DropdownMenuItem<String>(
                    value: genre,
                    child: Text(genre),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedGenre = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Год выпуска',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите год выпуска';
                  }
                  final year = int.tryParse(value);
                  if (year == null || year < 1900 || year > DateTime.now().year) {
                    return 'Введите корректный год';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Рейтинг: ${_rating.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 16),
              ),
              Slider(
                value: _rating,
                min: 1.0,
                max: 10.0,
                divisions: 90,
                label: _rating.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitMovie,
                  child: const Text('Добавить фильм'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

