import 'package:flutter/material.dart';

class AddMovieScreen extends StatefulWidget {
  final Function({
  required String title,
  required String description,
  required String genre,
  required int year,
  required double rating,
  }) onAddMovie;

  const AddMovieScreen({
    super.key,
    required this.onAddMovie,
  });

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
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

  void _submitMovie() {
    if (_formKey.currentState!.validate()) {
      widget.onAddMovie(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        genre: _selectedGenre,
        year: int.parse(_yearController.text),
        rating: _rating,
      );
      Navigator.pop(context);
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
              // Название
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

              // Описание
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

              // Жанр
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

              // Год выпуска
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

              // Рейтинг
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

              // Кнопка сохранения
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
