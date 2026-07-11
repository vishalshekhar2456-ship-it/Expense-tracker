import 'package:expenseful/data/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// Single shared AppDatabase instance for the whole app.
/// keepAlive: true — the database connection should never be disposed
/// just because a screen watching it goes off-screen.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  return AppDatabase();
}