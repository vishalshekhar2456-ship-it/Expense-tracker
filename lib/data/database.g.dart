// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('INR'));
  static const VerificationMeta _dateFormatMeta =
      const VerificationMeta('dateFormat');
  @override
  late final GeneratedColumn<String> dateFormat = GeneratedColumn<String>(
      'date_format', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('dd/MM/yyyy'));
  static const VerificationMeta _themeVariantMeta =
      const VerificationMeta('themeVariant');
  @override
  late final GeneratedColumn<String> themeVariant = GeneratedColumn<String>(
      'theme_variant', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('warm'));
  static const VerificationMeta _budgetResetDayMeta =
      const VerificationMeta('budgetResetDay');
  @override
  late final GeneratedColumn<int> budgetResetDay = GeneratedColumn<int>(
      'budget_reset_day', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [id, currencyCode, dateFormat, themeVariant, budgetResetDay];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSettingsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    }
    if (data.containsKey('date_format')) {
      context.handle(
          _dateFormatMeta,
          dateFormat.isAcceptableOrUnknown(
              data['date_format']!, _dateFormatMeta));
    }
    if (data.containsKey('theme_variant')) {
      context.handle(
          _themeVariantMeta,
          themeVariant.isAcceptableOrUnknown(
              data['theme_variant']!, _themeVariantMeta));
    }
    if (data.containsKey('budget_reset_day')) {
      context.handle(
          _budgetResetDayMeta,
          budgetResetDay.isAcceptableOrUnknown(
              data['budget_reset_day']!, _budgetResetDayMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      dateFormat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_format'])!,
      themeVariant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_variant'])!,
      budgetResetDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}budget_reset_day'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingsData extends DataClass implements Insertable<AppSettingsData> {
  final int id;
  final String currencyCode;
  final String dateFormat;
  final String themeVariant;
  final int budgetResetDay;
  const AppSettingsData(
      {required this.id,
      required this.currencyCode,
      required this.dateFormat,
      required this.themeVariant,
      required this.budgetResetDay});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['currency_code'] = Variable<String>(currencyCode);
    map['date_format'] = Variable<String>(dateFormat);
    map['theme_variant'] = Variable<String>(themeVariant);
    map['budget_reset_day'] = Variable<int>(budgetResetDay);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      currencyCode: Value(currencyCode),
      dateFormat: Value(dateFormat),
      themeVariant: Value(themeVariant),
      budgetResetDay: Value(budgetResetDay),
    );
  }

  factory AppSettingsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsData(
      id: serializer.fromJson<int>(json['id']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      dateFormat: serializer.fromJson<String>(json['dateFormat']),
      themeVariant: serializer.fromJson<String>(json['themeVariant']),
      budgetResetDay: serializer.fromJson<int>(json['budgetResetDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'dateFormat': serializer.toJson<String>(dateFormat),
      'themeVariant': serializer.toJson<String>(themeVariant),
      'budgetResetDay': serializer.toJson<int>(budgetResetDay),
    };
  }

  AppSettingsData copyWith(
          {int? id,
          String? currencyCode,
          String? dateFormat,
          String? themeVariant,
          int? budgetResetDay}) =>
      AppSettingsData(
        id: id ?? this.id,
        currencyCode: currencyCode ?? this.currencyCode,
        dateFormat: dateFormat ?? this.dateFormat,
        themeVariant: themeVariant ?? this.themeVariant,
        budgetResetDay: budgetResetDay ?? this.budgetResetDay,
      );
  AppSettingsData copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingsData(
      id: data.id.present ? data.id.value : this.id,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      dateFormat:
          data.dateFormat.present ? data.dateFormat.value : this.dateFormat,
      themeVariant: data.themeVariant.present
          ? data.themeVariant.value
          : this.themeVariant,
      budgetResetDay: data.budgetResetDay.present
          ? data.budgetResetDay.value
          : this.budgetResetDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsData(')
          ..write('id: $id, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('themeVariant: $themeVariant, ')
          ..write('budgetResetDay: $budgetResetDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, currencyCode, dateFormat, themeVariant, budgetResetDay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsData &&
          other.id == this.id &&
          other.currencyCode == this.currencyCode &&
          other.dateFormat == this.dateFormat &&
          other.themeVariant == this.themeVariant &&
          other.budgetResetDay == this.budgetResetDay);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingsData> {
  final Value<int> id;
  final Value<String> currencyCode;
  final Value<String> dateFormat;
  final Value<String> themeVariant;
  final Value<int> budgetResetDay;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.dateFormat = const Value.absent(),
    this.themeVariant = const Value.absent(),
    this.budgetResetDay = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.dateFormat = const Value.absent(),
    this.themeVariant = const Value.absent(),
    this.budgetResetDay = const Value.absent(),
  });
  static Insertable<AppSettingsData> custom({
    Expression<int>? id,
    Expression<String>? currencyCode,
    Expression<String>? dateFormat,
    Expression<String>? themeVariant,
    Expression<int>? budgetResetDay,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (dateFormat != null) 'date_format': dateFormat,
      if (themeVariant != null) 'theme_variant': themeVariant,
      if (budgetResetDay != null) 'budget_reset_day': budgetResetDay,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? currencyCode,
      Value<String>? dateFormat,
      Value<String>? themeVariant,
      Value<int>? budgetResetDay}) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      currencyCode: currencyCode ?? this.currencyCode,
      dateFormat: dateFormat ?? this.dateFormat,
      themeVariant: themeVariant ?? this.themeVariant,
      budgetResetDay: budgetResetDay ?? this.budgetResetDay,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (dateFormat.present) {
      map['date_format'] = Variable<String>(dateFormat.value);
    }
    if (themeVariant.present) {
      map['theme_variant'] = Variable<String>(themeVariant.value);
    }
    if (budgetResetDay.present) {
      map['budget_reset_day'] = Variable<int>(budgetResetDay.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('themeVariant: $themeVariant, ')
          ..write('budgetResetDay: $budgetResetDay')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [appSettings];
}

typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<int> id,
  Value<String> currencyCode,
  Value<String> dateFormat,
  Value<String> themeVariant,
  Value<int> budgetResetDay,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<int> id,
  Value<String> currencyCode,
  Value<String> dateFormat,
  Value<String> themeVariant,
  Value<int> budgetResetDay,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateFormat => $composableBuilder(
      column: $table.dateFormat, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get themeVariant => $composableBuilder(
      column: $table.themeVariant, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get budgetResetDay => $composableBuilder(
      column: $table.budgetResetDay,
      builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateFormat => $composableBuilder(
      column: $table.dateFormat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get themeVariant => $composableBuilder(
      column: $table.themeVariant,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get budgetResetDay => $composableBuilder(
      column: $table.budgetResetDay,
      builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);

  GeneratedColumn<String> get dateFormat => $composableBuilder(
      column: $table.dateFormat, builder: (column) => column);

  GeneratedColumn<String> get themeVariant => $composableBuilder(
      column: $table.themeVariant, builder: (column) => column);

  GeneratedColumn<int> get budgetResetDay => $composableBuilder(
      column: $table.budgetResetDay, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSettingsData,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (
      AppSettingsData,
      BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingsData>
    ),
    AppSettingsData,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<String> dateFormat = const Value.absent(),
            Value<String> themeVariant = const Value.absent(),
            Value<int> budgetResetDay = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            id: id,
            currencyCode: currencyCode,
            dateFormat: dateFormat,
            themeVariant: themeVariant,
            budgetResetDay: budgetResetDay,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<String> dateFormat = const Value.absent(),
            Value<String> themeVariant = const Value.absent(),
            Value<int> budgetResetDay = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            id: id,
            currencyCode: currencyCode,
            dateFormat: dateFormat,
            themeVariant: themeVariant,
            budgetResetDay: budgetResetDay,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSettingsData,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (
      AppSettingsData,
      BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingsData>
    ),
    AppSettingsData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
