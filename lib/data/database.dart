import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'models/app_settings.dart';

part 'database.g.dart';

@DriftDatabase(tables: [AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // Seed the single settings row on first launch.
          await into(appSettings).insert(const AppSettingsCompanion());
        },
      );
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'expenseful_db',
  );
}