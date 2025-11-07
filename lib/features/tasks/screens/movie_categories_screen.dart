import 'package:flutter/material.dart';
import 'category_movies_screen.dart';

class MovieCategoriesScreen extends StatefulWidget {
  const MovieCategoriesScreen({super.key});

  @override
  State<MovieCategoriesScreen> createState() => _MovieCategoriesScreenState();
}

class _MovieCategoriesScreenState extends State<MovieCategoriesScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, dynamic>> categories = const [
    {'name': 'Боевик', 'icon': Icons.local_fire_department, 'color': Colors.red},
    {'name': 'Комедия', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.orange},
    {'name': 'Драма', 'icon': Icons.theater_comedy, 'color': Colors.purple},
    {'name': 'Фантастика', 'icon': Icons.rocket_launch, 'color': Colors.blue},
    {'name': 'Ужасы', 'icon': Icons.warning, 'color': Colors.black87},
    {'name': 'Романтика', 'icon': Icons.favorite, 'color': Colors.pink},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории фильмов'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryPage(category, context);
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: _currentPage > 0
                    ? () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
                    : null,
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            Text(
              '${_currentPage + 1}/${categories.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: _currentPage < categories.length - 1
                    ? () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
                    : null,
                icon: const Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPage(Map<String, dynamic> category, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/category_movies',
          arguments: category['name'],
        );
      },
      child: Container(
        color: category['color'],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category['icon'],
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              category['name'],
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Нажмите, чтобы открыть',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '← Свайп влево/вправо →',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
