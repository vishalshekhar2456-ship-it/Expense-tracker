import 'package:expenseful/data/database.dart';
import 'package:expenseful/providers/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budgets_provider.g.dart';

/// Live stream of all per-category budget limits.
@riverpod
Stream<List<Budget>> budgets(BudgetsRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchBudgets();
}
