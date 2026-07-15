import 'package:expenseful/data/database.dart';
import 'package:drift/drift.dart';

/// Wraps the single-row AppSettings table. Callers never deal with row ids
/// or raw Drift types beyond AppSettingsData/AppSettingsCompanion — this
/// repository is the only place that knows the settings table has exactly
/// one row.
class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  static const int _settingsRowId = 1;

  /// Emits the current settings row, and again every time it changes.
  Stream<AppSettingsData> watchSettings() {
    return (_db.select(_db.appSettings)
          ..where((tbl) => tbl.id.equals(_settingsRowId)))
        .watchSingle();
  }

  /// One-time read, for cases where a stream isn't needed (e.g. reading
  /// currency once before an export or a PDF generation step).
  Future<AppSettingsData> getSettings() {
    return (_db.select(_db.appSettings)
          ..where((tbl) => tbl.id.equals(_settingsRowId)))
        .getSingle();
  }

  /// General-purpose update — pass only the fields you want to change,
  /// leave the rest as Value.absent() (the default for unset fields in
  /// a Companion).
  Future<void> updateSettings(AppSettingsCompanion updated) {
    return (_db.update(_db.appSettings)
          ..where((tbl) => tbl.id.equals(_settingsRowId)))
        .write(updated);
  }

  /// Convenience wrapper for the most common single-field update.
  Future<void> updateCurrency(String currencyCode) {
    return updateSettings(
      AppSettingsCompanion(currencyCode: Value(currencyCode)),
    );
  }

  /// Sets (or clears, with null) the overall monthly budget cap.
  Future<void> updateMonthlyBudget(double? amount) {
    return updateSettings(
      AppSettingsCompanion(monthlyBudget: Value(amount)),
    );
  }
}