import 'package:expenseful/data/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'settings_repository_provider.dart';

part 'settings_provider.g.dart';

/// Live stream of the app's single settings row. Any widget watching this
/// rebuilds automatically the moment currency, theme, date format, or
/// budget reset day changes anywhere in the app.
@riverpod
Stream<AppSettingsData> settings(SettingsRef ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.watchSettings();
}