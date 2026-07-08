// import 'dart:io';

// import 'package:drift/drift.dart';
// import 'package:drift/native.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';


// /// -----------------------------------------------------------------------
// /// Tables
// /// -----------------------------------------------------------------------

// /// A spending category (Food, Transport, etc). Color maps to one of the
// /// six brand category colors defined in [AppColors.categoryPalette].
// class Categories extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get name => text().withLength(min: 1, max: 40)();

//   /// Index into AppColors.categoryPalette (0-5) rather than storing a raw
//   /// hex value — keeps the palette centralized in the theme file.
//   IntColumn get colorIndex => integer().withDefault(const Constant(0))();

//   /// Material icon codepoint, or an asset key — decide when building
//   /// the category picker UI.
//   TextColumn get iconKey => text().nullable()();

//   DateTimeColumn get createdAt =>
//       dateTime().withDefault(currentDateAndTime)();
// }

// /// A free-form label a user can attach to expenses (many-to-many).
// class Tags extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get name => text().withLength(min: 1, max: 30).unique()();
// }

// /// A recurring expense rule (e.g. "Netflix, ₹500, monthly on the 5th").
// /// Individual generated Expenses reference this via [recurringRuleId].
// class RecurringRules extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get label => text()();
//   RealColumn get amount => real()();
//   IntColumn get categoryId =>
//       integer().references(Categories, #id, onDelete: KeyAction.setNull).nullable()();

//   /// 'daily' | 'weekly' | 'monthly' | 'yearly' — kept as text for now;
//   /// promote to a Dart enum + EnumTextColumn once frequency options solidify.
//   TextColumn get frequency => text()();

//   /// Day-of-month (1-31) for monthly/yearly rules, or weekday (1-7) for
//   /// weekly rules. Nullable because daily rules don't need it.
//   IntColumn get anchorDay => integer().nullable()();

//   /// If true, expenses are logged automatically when due.
//   /// If false, the user is prompted to confirm each cycle
//   /// (Recurring confirmation sheet).
//   BoolColumn get autoLogEnabled =>
//       boolean().withDefault(const Constant(false))();

//   DateTimeColumn get lastGeneratedDate => dateTime().nullable()();
//   DateTimeColumn get createdAt =>
//       dateTime().withDefault(currentDateAndTime)();
// }

// /// A single logged expense.
// class Expenses extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   RealColumn get amount => real()();
//   TextColumn get note => text().nullable()();
//   DateTimeColumn get date => dateTime()();

//   IntColumn get categoryId =>
//       integer().references(Categories, #id, onDelete: KeyAction.setNull).nullable()();

//   /// Set only if this expense was generated from (or confirmed from)
//   /// a recurring rule — lets History/Insights distinguish recurring vs
//   /// one-off spend without duplicating rule data onto every row.
//   IntColumn get recurringRuleId => integer()
//       .references(RecurringRules, #id, onDelete: KeyAction.setNull)
//       .nullable()();

//   DateTimeColumn get createdAt =>
//       dateTime().withDefault(currentDateAndTime)();
// }

// /// Many-to-many join table between Expenses and Tags.
// class ExpenseTags extends Table {
//   IntColumn get expenseId =>
//       integer().references(Expenses, #id, onDelete: KeyAction.cascade)();
//   IntColumn get tagId =>
//       integer().references(Tags, #id, onDelete: KeyAction.cascade)();

//   @override
//   Set<Column> get primaryKey => {expenseId, tagId};
// }

// /// Single-row table for app-wide settings. Enforced to one row via
// /// a fixed id = 0 (see [AppSettingsDao.ensureDefaultRow]).
// class AppSettings extends Table {
//   IntColumn get id => integer()();
//   TextColumn get currencyCode => text().withDefault(const Constant('INR'))();

//   /// 'auto' (device-detected) or 'manual'
//   TextColumn get localeMode => text().withDefault(const Constant('auto'))();

//   @override
//   Set<Column> get primaryKey => {id};
// }

// /// -----------------------------------------------------------------------
// /// Database
// /// -----------------------------------------------------------------------

// @DriftDatabase(
//   tables: [Categories, Tags, RecurringRules, Expenses, ExpenseTags, AppSettings],
// )
// class AppDatabase extends _$AppDatabase {
//   AppDatabase() : super(_openConnection());

//   // Bump this and add a MigrationStrategy step whenever the schema changes
//   // post-v1, so existing users' local data isn't wiped on upgrade.
//   @override
//   int get schemaVersion => 1;

//   @override
//   MigrationStrategy get migration => MigrationStrategy(
//         onCreate: (m) async {
//           await m.createAll();
//         },
//         // onUpgrade: (m, from, to) async { ... } — add here as schema evolves.
//       );
// }

// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'expenseful.sqlite'));
//     return NativeDatabase.createInBackground(file);
//   });
// }
