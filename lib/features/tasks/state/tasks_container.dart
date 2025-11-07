import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/movie.dart';
import '../screens/auth_screen.dart';
import '../screens/register_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/movies_list_screen.dart';
import '../screens/add_movie_screen.dart';
import '../screens/settings_screen.dart';

enum AppScreen { auth, register, main }

class TasksContainer extends StatefulWidget {
  const TasksContainer({super.key});

  @override
  State<TasksContainer> createState() => _TasksContainerState();
}

class _TasksContainerState extends State<TasksContainer> {
  AppScreen _currentScreen = AppScreen.auth;
  User? _currentUser;
  List<Movie> _movies = [];
  int _currentTabIndex = 0;
  bool _rememberMe = false;
  bool _acceptTerms = false;
  bool _notificationsEnabled = true;
  bool _isDarkTheme = false;

  // Навигационные методы
  void _showAuthScreen() {
    setState(() {
      _currentScreen = AppScreen.auth;
    });
  }

  void _showRegisterScreen() {
    setState(() {
      _currentScreen = AppScreen.register;
    });
  }

  void _showMainScreen() {
    setState(() {
      _currentScreen = AppScreen.main;
    });
  }

  // Методы аутентификации
  void _login(String email, String password, bool rememberMe) {
    // Простая имитация логики входа
    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _currentUser = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          email: email,
          name: email.split('@')[0],
          createdAt: DateTime.now(),
        );
        _rememberMe = rememberMe;
        _currentScreen = AppScreen.main;
      });
    }
  }

  void _register(String name, String email, String password, bool acceptTerms) {
    // Простая имитация логики регистрации
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && acceptTerms) {
      setState(() {
        _currentUser = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          email: email,
          name: name,
          createdAt: DateTime.now(),
        );
        _acceptTerms = acceptTerms;
        _currentScreen = AppScreen.main;
      });
    }
  }

  void _logout() {
    setState(() {
      _currentUser = null;
      _currentScreen = AppScreen.auth;
      _currentTabIndex = 0;
    });
  }

  // Методы работы с фильмами
  void _addMovie({
    required String title,
    required String description,
    required String genre,
    required int year,
    required double rating,
  }) {
    final movie = Movie(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      genre: genre,
      year: year,
      rating: rating,
      isWatched: false,
      createdAt: DateTime.now(),
    );

    setState(() {
      _movies.add(movie);
    });
  }

  void _toggleMovieWatched(String movieId) {
    final index = _movies.indexWhere((movie) => movie.id == movieId);
    if (index != -1) {
      setState(() {
        _movies[index] = _movies[index].copyWith(
          isWatched: !_movies[index].isWatched,
        );
      });
    }
  }

  void _deleteMovie(String movieId) {
    final movieIndex = _movies.indexWhere((movie) => movie.id == movieId);
    if (movieIndex != -1) {
      final deletedMovie = _movies[movieIndex];

      setState(() {
        _movies.removeAt(movieIndex);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Фильм "${deletedMovie.title}" удален'),
          action: SnackBarAction(
            label: 'Отменить',
            onPressed: () {
              setState(() {
                _movies.insert(movieIndex, deletedMovie);
              });
            },
          ),
        ),
      );
    }
  }

  void _updateSettings({bool? notifications, bool? darkTheme}) {
    setState(() {
      if (notifications != null) _notificationsEnabled = notifications;
      if (darkTheme != null) _isDarkTheme = darkTheme;
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentScreen == AppScreen.auth) {
      return AuthScreen(
        onLogin: _login,
        onNavigateToRegister: _showRegisterScreen,
      );
    }

    if (_currentScreen == AppScreen.register) {
      return RegisterScreen(
        onRegister: _register,
        onNavigateToLogin: _showAuthScreen,
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          MoviesListScreen(
            movies: _movies,
            onAddMovie: () => _showAddMovieScreen(),
            onToggleWatched: _toggleMovieWatched,
            onDeleteMovie: _deleteMovie,
          ),
          ProfileScreen(
            user: _currentUser!,
            onLogout: _logout,
          ),
          SettingsScreen(
            notificationsEnabled: _notificationsEnabled,
            isDarkTheme: _isDarkTheme,
            onUpdateSettings: _updateSettings,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: _onTabChanged,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Фильмы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }

  void _showAddMovieScreen() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddMovieScreen(onAddMovie: _addMovie),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

}
