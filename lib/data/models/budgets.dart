import 'package:drift/drift.dart';

/// One monthly budget limit per category. The category id is the primary key,
/// so there is at most one budget row per category (upsert on save).
class Budgets extends Table {
  /// Category this budget applies to (Categories.id).
  TextColumn get categoryId => text()();

  /// Monthly limit for the category.
  RealColumn get amount => real()();

  /// Last modification timestamp.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {categoryId};
}
