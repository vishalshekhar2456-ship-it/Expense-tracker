import 'package:expenseful/data/database.dart';
import 'package:expenseful/providers/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories_provider.g.dart';

@riverpod
Stream<List<Category>> categories(CategoriesRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchCategories();
}