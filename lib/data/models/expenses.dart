import 'package:drift/drift.dart';

class Expenses extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Transaction amount
  RealColumn get amount => real()();

  /// Merchant or payee
  TextColumn get merchant => text()();

  /// Optional notes
  TextColumn get notes => text().nullable()();

  /// Expense date
  DateTimeColumn get date => dateTime()();

  /// Category UUID (foreign key later)
  TextColumn get categoryId => text().nullable()();

  /// Record creation time
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last update time
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// Soft delete flag (useful for future sync)
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
