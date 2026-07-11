import 'package:drift/drift.dart';

class Categories extends Table {
  /// UUID
  TextColumn get id => text()();

  /// Display name
  TextColumn get name => text()();

  /// Icon key (e.g. "restaurant")
  TextColumn get icon => text()();

  /// Color key (e.g. "coral")
  TextColumn get color => text()();

  /// Display order
  IntColumn get sortOrder => integer()();

  /// Default categories cannot be deleted
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  /// Hide instead of deleting
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last modification timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
