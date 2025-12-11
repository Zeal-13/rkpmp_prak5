import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Database
import '../database/database.dart';

// Network
import '../network/dio_client.dart';

// Features - Auth
import '../../features/auth/data/datasources/auth_drift_data_source.dart';
import '../../features/auth/data/datasources/auth_shared_prefs_data_source.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';

// Features - Movies
import '../../features/movies/data/datasources/movies_drift_data_source.dart';
import '../../features/movies/data/datasources/movies_shared_prefs_data_source.dart';
import '../../features/movies/data/datasources/movies_local_data_source.dart';
import '../../features/movies/data/datasources/movies_remote_data_source.dart';
import '../../features/movies/data/repositories/movies_repository_impl.dart';
import '../../features/movies/domain/repositories/movies_repository.dart';
import '../../features/movies/domain/usecases/get_movies_usecase.dart';
import '../../features/movies/domain/usecases/add_movie_usecase.dart';
import '../../features/movies/domain/usecases/delete_movie_usecase.dart';
import '../../features/movies/domain/usecases/toggle_watched_usecase.dart';
import '../../features/movies/domain/usecases/search_movies_usecase.dart';
import '../../features/movies/domain/usecases/get_popular_movies_usecase.dart';
import '../../features/movies/domain/usecases/get_movie_details_usecase.dart';

// Features - Posts
import '../../features/posts/data/datasources/posts_remote_data_source.dart';

// Features - Settings
import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings_usecase.dart';
import '../../features/settings/domain/usecases/update_settings_usecase.dart';

final sl = GetIt.instance;

/// Initialize dependency injection container
Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //! Database (Drift SQL) - только для нативных платформ
  if (!kIsWeb) {
    sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  }

  //! Network - Dio Clients для различных API
  // TMDB API Client
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: {'Content-Type': 'application/json'},
    ),
    instanceName: 'tmdb',
  );

  // ReqRes API Client
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      baseUrl: 'https://reqres.in/api',
      headers: {'Content-Type': 'application/json'},
    ),
    instanceName: 'reqres',
  );

  // JSONPlaceholder API Client
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      headers: {'Content-Type': 'application/json'},
    ),
    instanceName: 'jsonplaceholder',
  );

  //! Features - Auth (using Drift/SharedPreferences + ReqRes API)
  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => kIsWeb
        ? AuthSharedPrefsDataSource(sl<SharedPreferences>())
        : AuthDriftDataSource(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: sl<DioClient>(instanceName: 'reqres'),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  //! Features - Movies (using Drift/SharedPreferences + TMDB API)
  // Data sources
  sl.registerLazySingleton<MoviesLocalDataSource>(
    () => kIsWeb
        ? MoviesSharedPrefsDataSource(sl<SharedPreferences>())
        : MoviesDriftDataSource(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<MoviesRemoteDataSource>(
    () => MoviesRemoteDataSourceImpl(
      client: sl<DioClient>(instanceName: 'tmdb'),
    ),
  );

  // Repository
  sl.registerLazySingleton<MoviesRepository>(
    () => MoviesRepositoryImpl(sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMoviesUseCase(sl()));
  sl.registerLazySingleton(() => AddMovieUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMovieUseCase(sl()));
  sl.registerLazySingleton(() => ToggleWatchedUseCase(sl()));
  sl.registerLazySingleton(() => SearchMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetPopularMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetMovieDetailsUseCase(sl()));

  //! Features - Settings (using SharedPreferences)
  // Data sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSettingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSettingsUseCase(sl()));

  //! Features - Posts (using JSONPlaceholder API)
  // Data sources
  sl.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImpl(
      client: sl<DioClient>(instanceName: 'jsonplaceholder'),
    ),
  );
}
