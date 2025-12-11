import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../movies/domain/usecases/search_movies_usecase.dart';
import '../../../movies/domain/usecases/get_popular_movies_usecase.dart';
import '../../../movies/domain/usecases/get_movie_details_usecase.dart';
import '../../../auth/domain/usecases/login_usecase.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../../auth/domain/entities/user_entity.dart';

/// Экран для тестирования всех сетевых запросов
class NetworkRequestsPage extends ConsumerStatefulWidget {
  const NetworkRequestsPage({super.key});

  @override
  ConsumerState<NetworkRequestsPage> createState() => _NetworkRequestsPageState();
}

class _NetworkRequestsPageState extends ConsumerState<NetworkRequestsPage> {
  final _searchController = TextEditingController();
  final _movieIdController = TextEditingController();
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  List<MovieEntity> _searchResults = [];
  List<MovieEntity> _popularMovies = [];
  MovieEntity? _movieDetails;
  UserEntity? _loginResult;
  
  bool _isLoadingSearch = false;
  bool _isLoadingPopular = false;
  bool _isLoadingDetails = false;
  bool _isLoadingLogin = false;

  String? _errorSearch;
  String? _errorPopular;
  String? _errorDetails;
  String? _errorLogin;

  @override
  void dispose() {
    _searchController.dispose();
    _movieIdController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  Future<void> _searchMovies() async {
    if (_searchController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите запрос для поиска')),
      );
      return;
    }

    setState(() {
      _isLoadingSearch = true;
      _errorSearch = null;
      _searchResults = [];
    });

    try {
      final useCase = di.sl<SearchMoviesUseCase>();
      final results = await useCase(_searchController.text.trim());
      setState(() {
        _searchResults = results;
        _isLoadingSearch = false;
      });
    } catch (e) {
      setState(() {
        _errorSearch = e.toString();
        _isLoadingSearch = false;
      });
    }
  }

  Future<void> _getPopularMovies() async {
    setState(() {
      _isLoadingPopular = true;
      _errorPopular = null;
      _popularMovies = [];
    });

    try {
      final useCase = di.sl<GetPopularMoviesUseCase>();
      final results = await useCase();
      setState(() {
        _popularMovies = results;
        _isLoadingPopular = false;
      });
    } catch (e) {
      setState(() {
        _errorPopular = e.toString();
        _isLoadingPopular = false;
      });
    }
  }

  Future<void> _getMovieDetails() async {
    if (_movieIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите ID фильма')),
      );
      return;
    }

    final movieId = int.tryParse(_movieIdController.text.trim());
    if (movieId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите корректный ID фильма (число)')),
      );
      return;
    }

    setState(() {
      _isLoadingDetails = true;
      _errorDetails = null;
      _movieDetails = null;
    });

    try {
      final useCase = di.sl<GetMovieDetailsUseCase>();
      final movie = await useCase(movieId);
      setState(() {
        _movieDetails = movie;
        _isLoadingDetails = false;
      });
    } catch (e) {
      setState(() {
        _errorDetails = e.toString();
        _isLoadingDetails = false;
      });
    }
  }

  Future<void> _login() async {
    if (_loginEmailController.text.trim().isEmpty ||
        _loginPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите email и пароль')),
      );
      return;
    }

    setState(() {
      _isLoadingLogin = true;
      _errorLogin = null;
      _loginResult = null;
    });

    try {
      final useCase = di.sl<LoginUseCase>();
      final user = await useCase(
        email: _loginEmailController.text.trim(),
        password: _loginPasswordController.text.trim(),
      );
      setState(() {
        _loginResult = user;
        _isLoadingLogin = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Успешный вход: ${user.name}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _errorLogin = e.toString();
        _isLoadingLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сетевые запросы'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TMDB API - Поиск фильмов
            _buildSection(
              title: '1. TMDB API - Поиск фильмов',
              icon: Icons.search,
              color: Colors.blue,
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Запрос для поиска',
                      hintText: 'Например: Inception',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _isLoadingSearch ? null : _searchMovies,
                    icon: _isLoadingSearch
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search),
                    label: const Text('Поиск'),
                  ),
                  if (_errorSearch != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Ошибка: $_errorSearch',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (_searchResults.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Найдено: ${_searchResults.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._searchResults.take(3).map((movie) => Card(
                          child: ListTile(
                            title: Text(movie.title),
                            subtitle: Text('${movie.year} • ${movie.genre}'),
                            trailing: Text('⭐ ${movie.rating.toStringAsFixed(1)}'),
                          ),
                        )),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TMDB API - Популярные фильмы
            _buildSection(
              title: '2. TMDB API - Популярные фильмы',
              icon: Icons.trending_up,
              color: Colors.green,
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isLoadingPopular ? null : _getPopularMovies,
                    icon: _isLoadingPopular
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.trending_up),
                    label: const Text('Получить популярные фильмы'),
                  ),
                  if (_errorPopular != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Ошибка: $_errorPopular',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (_popularMovies.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Получено: ${_popularMovies.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._popularMovies.take(3).map((movie) => Card(
                          child: ListTile(
                            title: Text(movie.title),
                            subtitle: Text('${movie.year} • ${movie.genre}'),
                            trailing: Text('⭐ ${movie.rating.toStringAsFixed(1)}'),
                          ),
                        )),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TMDB API - Детали фильма
            _buildSection(
              title: '3. TMDB API - Детали фильма',
              icon: Icons.info,
              color: Colors.orange,
              child: Column(
                children: [
                  TextField(
                    controller: _movieIdController,
                    decoration: const InputDecoration(
                      labelText: 'ID фильма',
                      hintText: 'Например: 550 (Fight Club)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _isLoadingDetails ? null : _getMovieDetails,
                    icon: _isLoadingDetails
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.info),
                    label: const Text('Получить детали'),
                  ),
                  if (_errorDetails != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Ошибка: $_errorDetails',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (_movieDetails != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _movieDetails!.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Год: ${_movieDetails!.year}'),
                            Text('Жанр: ${_movieDetails!.genre}'),
                            Text('Рейтинг: ⭐ ${_movieDetails!.rating.toStringAsFixed(1)}'),
                            const SizedBox(height: 8),
                            Text(
                              _movieDetails!.description,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ReqRes API - Вход
            _buildSection(
              title: '4. ReqRes API - Вход пользователя',
              icon: Icons.login,
              color: Colors.purple,
              child: Column(
                children: [
                  TextField(
                    controller: _loginEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'eve.holt@reqres.in',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _loginPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Пароль',
                      hintText: 'cityslicka',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _isLoadingLogin ? null : _login,
                    icon: _isLoadingLogin
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.login),
                    label: const Text('Войти'),
                  ),
                  if (_errorLogin != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Ошибка: $_errorLogin',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (_loginResult != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Успешный вход!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('ID: ${_loginResult!.id}'),
                            Text('Имя: ${_loginResult!.name}'),
                            Text('Email: ${_loginResult!.email}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }
}


