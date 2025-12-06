import 'package:get_it/get_it.dart';


final sl = GetIt.instance;

class MovieStore {
  dynamic current;
}

void setupDI() {

  sl.registerLazySingleton<MovieStore>(() => MovieStore());

  sl.registerLazySingleton<MovieStore>(
        () => MovieStore(),
    instanceName: 'selectedMovie',
  );

  sl.registerLazySingleton<MovieStore>(
        () => MovieStore(),
    instanceName: 'recentMovie',
  );
}





