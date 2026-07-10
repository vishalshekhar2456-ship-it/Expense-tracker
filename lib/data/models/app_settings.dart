import 'package:drift/drift.dart';

@DataClassName('AppSettingsData')
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get currencyCode => text().withDefault(const Constant('INR'))();

  TextColumn get dateFormat => text().withDefault(const Constant('dd/MM/yyyy'))();

  TextColumn get themeVariant => text().withDefault(const Constant('warm'))();

  IntColumn get budgetResetDay => integer().withDefault(const Constant(1))();
}