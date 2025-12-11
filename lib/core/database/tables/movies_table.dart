import 'package:drift/drift.dart';

/// Movies table for SQL storage using Drift
class Movies extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get genre => text()();
  IntColumn get year => integer()();
  RealColumn get rating => real()();
  BoolColumn get isWatched => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

