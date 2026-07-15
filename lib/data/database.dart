import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

import 'models/app_settings.dart';
import 'models/expenses.dart';
import 'models/categories.dart';
import 'models/budgets.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    AppSettings,
    Expenses,
    Categories,
    Budgets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  static const Uuid _uuid = Uuid();

  @override
  int get schemaVersion => 3;

@override
MigrationStrategy get migration => MigrationStrategy(
  onUpgrade: (Migrator m, int from, int to) async {
    // v3: overall monthly budget + per-category Budgets table.
    if (from < 3) {
      await m.addColumn(appSettings, appSettings.monthlyBudget);
      await m.createTable(budgets);
    }
  },
  onCreate: (Migrator m) async {
    await m.createAll();

    // Seed the app settings row.
    await into(appSettings).insert(
      const AppSettingsCompanion(),
    );

    // Seed default categories.
    await batch((batch) {
      batch.insertAll(categories, [
        CategoriesCompanion.insert(
          id: 'food',
          name: 'Food',
          icon: 'restaurant',
          color: 'coral',
          sortOrder: 0,
          isDefault: const Value(true),
        ),
        CategoriesCompanion.insert(
          id: 'shopping',
          name: 'Shopping',
          icon: 'shopping_bag',
          color: 'marigold',
          sortOrder: 1,
          isDefault: const Value(true),
        ),
        CategoriesCompanion.insert(
          id: 'transport',
          name: 'Transport',
          icon: 'directions_car',
          color: 'teal',
          sortOrder: 2,
          isDefault: const Value(true),
        ),
        CategoriesCompanion.insert(
          id: 'utilities',
          name: 'Utilities',
          icon: 'bolt',
          color: 'grape',
          sortOrder: 3,
          isDefault: const Value(true),
        ),
        CategoriesCompanion.insert(
          id: 'fun',
          name: 'Fun',
          icon: 'movie',
          color: 'sky',
          sortOrder: 4,
          isDefault: const Value(true),
        ),
        CategoriesCompanion.insert(
          id: 'health',
          name: 'Health',
          icon: 'favorite',
          color: 'pink',
          sortOrder: 5,
          isDefault: const Value(true),
        ),
      ]);
    });
  },
);



  // ==========================================================================
  // Expense CRUD
  // ==========================================================================

  /// Creates a new expense and returns its UUID.
  Future<String> addExpense({
    required double amount,
    required String merchant,
    String? notes,
    required DateTime date,
    String? categoryId,
  }) async {
    final id = _uuid.v4();

    await into(expenses).insert(
      ExpensesCompanion.insert(
        id: id,
        amount: amount,
        merchant: merchant,
        notes: Value(notes),
        date: date,
        categoryId: Value(categoryId),
      ),
    );

    return id;
  }

  /// Returns all non-deleted expenses ordered by date.
  Future<List<Expense>> getExpenses() {
    return (select(expenses)
          ..where((e) => e.isDeleted.equals(false))
          ..orderBy([
            (e) => OrderingTerm.desc(e.date),
          ]))
        .get();
  }

  /// Watches all non-deleted expenses.
  Stream<List<Expense>> watchExpenses() {
    return (select(expenses)
          ..where((e) => e.isDeleted.equals(false))
          ..orderBy([
            (e) => OrderingTerm.desc(e.date),
          ]))
        .watch();
  }

  /// Returns a single expense by ID.
  Future<Expense?> getExpense(String id) {
    return (select(expenses)
          ..where((e) => e.id.equals(id)))
        .getSingleOrNull();
  }

  /// Updates an expense.
  Future<bool> updateExpense(Expense expense) {
    return update(expenses).replace(expense);
  }

  /// Soft deletes an expense.
  Future<void> deleteExpense(String id) {
    return (update(expenses)
          ..where((e) => e.id.equals(id)))
        .write(
      ExpensesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Restores a soft-deleted expense.
  Future<void> restoreExpense(String id) {
    return (update(expenses)
          ..where((e) => e.id.equals(id)))
        .write(
      ExpensesCompanion(
        isDeleted: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }


// ==========================================================================
// Category CRUD
// ==========================================================================

Future<String> addCategory({
  required String name,
  required String icon,
  required String color,
}) async {
  final id = _uuid.v4();

  final maxOrder = await (selectOnly(categories)
        ..addColumns([categories.sortOrder.max()]))
      .getSingle();

  final nextOrder =
      (maxOrder.read(categories.sortOrder.max()) ?? -1) + 1;

  await into(categories).insert(
    CategoriesCompanion.insert(
      id: id,
      name: name,
      icon: icon,
      color: color,
      sortOrder: nextOrder,
    ),
  );

  return id;
}

Future<List<Category>> getCategories() {
  return (select(categories)
        ..where((c) => c.isArchived.equals(false))
        ..orderBy([
          (c) => OrderingTerm.asc(c.sortOrder),
        ]))
      .get();
}

Stream<List<Category>> watchCategories() {
  return (select(categories)
        ..where((c) => c.isArchived.equals(false))
        ..orderBy([
          (c) => OrderingTerm.asc(c.sortOrder),
        ]))
      .watch();
}

Future<Category?> getCategory(String id) {
  return (select(categories)
        ..where((c) => c.id.equals(id)))
      .getSingleOrNull();
}

Future<bool> updateCategory(Category category) {
  return update(categories).replace(category);
}

Future<void> archiveCategory(String id) async {
  await (update(categories)
        ..where((c) => c.id.equals(id)))
      .write(
    CategoriesCompanion(
      isArchived: const Value(true),
      updatedAt: Value(DateTime.now()),
    ),
  );
}

Future<void> restoreCategory(String id) async {
  await (update(categories)
        ..where((c) => c.id.equals(id)))
      .write(
    CategoriesCompanion(
      isArchived: const Value(false),
      updatedAt: Value(DateTime.now()),
    ),
  );
}

// ==========================================================================
// Budget CRUD (per-category limits)
// ==========================================================================

/// Watches all per-category budget limits.
Stream<List<Budget>> watchBudgets() {
  return select(budgets).watch();
}

/// Creates or updates the budget limit for a category.
Future<void> setBudget(String categoryId, double amount) {
  return into(budgets).insertOnConflictUpdate(
    BudgetsCompanion(
      categoryId: Value(categoryId),
      amount: Value(amount),
      updatedAt: Value(DateTime.now()),
    ),
  );
}

/// Removes the budget limit for a category.
Future<void> deleteBudget(String categoryId) {
  return (delete(budgets)..where((b) => b.categoryId.equals(categoryId))).go();
}
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'expenseful_db',
  );
}