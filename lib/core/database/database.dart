import 'package:drift/drift.dart';
import 'tables/movies_table.dart';
import 'tables/users_table.dart';

// Условные импорты для разных платформ
import 'database_stub.dart'
    if (dart.library.io) 'database_native.dart'
    if (dart.library.html) 'database_web.dart';

part 'database.g.dart';

/// Main database class using Drift
@DriftDatabase(tables: [Movies, Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations here if schema version changes
      },
    );
  }
}

/// Open database connection (platform-specific)
LazyDatabase _openConnection() {
  return createDatabase();
}

