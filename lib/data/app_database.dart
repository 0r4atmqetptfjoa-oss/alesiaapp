import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// A simple key/value settings table. This can store preferences
/// such as volume levels, parental PIN hash, entitlement flags and
/// timestamps used for tracking ad grace periods.
class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The main application database. Drift generates the _$AppDatabase
/// class in `app_database.g.dart` when running build_runner. For
/// demonstration purposes, only a simple settings table is defined.
@DriftDatabase(tables: [Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          FlutterQueryExecutor.inDatabaseFolder(
            path: 'app.db',
            logStatements: false,
          ),
        );

  @override
  int get schemaVersion => 1;

  /// Reads a setting by key. Returns null if not set.
  Future<String?> readSetting(String key) async {
    final query = select(settings)..where((tbl) => tbl.key.equals(key));
    final row = await query.getSingleOrNull();
    return row?.value;
  }

  /// Writes a setting (key/value). If the key already exists it
  /// updates the row; otherwise inserts a new row.
  Future<void> writeSetting(String key, String value) async {
    final existing = await (select(settings)
          ..where((tbl) => tbl.key.equals(key)))
        .getSingleOrNull();
    if (existing == null) {
      await into(settings).insert(SettingsCompanion(
        key: Value(key),
        value: Value(value),
      ));
    } else {
      await (update(settings)
            ..where((tbl) => tbl.key.equals(key)))
          .write(SettingsCompanion(value: Value(value)));
    }
  }
}