import 'package:expenseful/data/database.dart';
import 'package:expenseful/providers/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories_provider.g.dart';

@riverpod
Stream<List<Category>> categories(CategoriesRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchCategories();
}

/// All categories including archived ones — for the management screen and for
/// resolving icon/color of expenses whose category was later archived.
@riverpod
Stream<List<Category>> allCategories(AllCategoriesRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchAllCategories();
}