import 'package:expenseful/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:expenseful/data/database.dart';

part 'settings_repository_provider.g.dart';

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return SettingsRepository(db);
}