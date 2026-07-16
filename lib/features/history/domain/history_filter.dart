import 'package:flutter/material.dart';
import 'package:expenseful/data/database.dart';

/// Immutable set of criteria the history screen filters expenses by.
///
/// Kept as UI-local state (the history screen owns one and rebuilds on
/// change) rather than a global provider — filtering is a view concern and
/// shouldn't outlive the screen.
@immutable
class HistoryFilter {
  /// Free-text match against merchant and notes (case-insensitive).
  final String query;

  /// Inclusive day range; null means no date constraint.
  final DateTimeRange? dateRange;

  /// Category IDs to keep; empty means all categories.
  final Set<String> categoryIds;

  const HistoryFilter({
    this.query = '',
    this.dateRange,
    this.categoryIds = const {},
  });

  bool get isActive =>
      query.trim().isNotEmpty || dateRange != null || categoryIds.isNotEmpty;

  /// [copyWith] can't null-out [dateRange] (a null argument means "keep"), so
  /// clearing the range uses the explicit [clearDateRange] flag.
  HistoryFilter copyWith({
    String? query,
    DateTimeRange? dateRange,
    bool clearDateRange = false,
    Set<String>? categoryIds,
  }) {
    return HistoryFilter(
      query: query ?? this.query,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
      categoryIds: categoryIds ?? this.categoryIds,
    );
  }

  /// Whether [expense] passes every active criterion.
  bool matches(Expense expense) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isNotEmpty) {
      final merchant = expense.merchant.toLowerCase();
      final notes = (expense.notes ?? '').toLowerCase();
      if (!merchant.contains(trimmed) && !notes.contains(trimmed)) {
        return false;
      }
    }

    if (categoryIds.isNotEmpty &&
        (expense.categoryId == null ||
            !categoryIds.contains(expense.categoryId))) {
      return false;
    }

    if (dateRange != null) {
      final day = DateUtils.dateOnly(expense.date);
      final start = DateUtils.dateOnly(dateRange!.start);
      final end = DateUtils.dateOnly(dateRange!.end);
      if (day.isBefore(start) || day.isAfter(end)) return false;
    }

    return true;
  }
}

/// How the history list buckets expenses into sections.
enum HistoryGrouping { day, month }

/// A single date bucket (one day or one month) with its expenses and running
/// total, used to render a section of the grouped history list.
@immutable
class ExpenseGroup {
  /// Start of the period: the day (date-only) or the first day of the month,
  /// used as a stable key and for header formatting.
  final DateTime period;
  final HistoryGrouping grouping;
  final List<Expense> expenses;
  final double total;

  const ExpenseGroup({
    required this.period,
    required this.grouping,
    required this.expenses,
    required this.total,
  });
}

/// Groups [expenses] into consecutive day- or month-buckets, preserving the
/// input order (the DB hands them back newest-first, so groups come out
/// newest-first too). Each group's [ExpenseGroup.total] sums its amounts.
List<ExpenseGroup> groupExpenses(
  List<Expense> expenses,
  HistoryGrouping grouping,
) {
  DateTime keyOf(DateTime date) => grouping == HistoryGrouping.day
      ? DateTime(date.year, date.month, date.day)
      : DateTime(date.year, date.month);

  final groups = <ExpenseGroup>[];
  DateTime? currentKey;
  var currentItems = <Expense>[];
  var currentTotal = 0.0;

  void flush() {
    if (currentItems.isEmpty) return;
    groups.add(ExpenseGroup(
      period: currentKey!,
      grouping: grouping,
      expenses: currentItems,
      total: currentTotal,
    ));
  }

  for (final expense in expenses) {
    final key = keyOf(expense.date);
    if (currentKey == null || key != currentKey) {
      flush();
      currentKey = key;
      currentItems = <Expense>[];
      currentTotal = 0.0;
    }
    currentItems.add(expense);
    currentTotal += expense.amount;
  }
  flush();

  return groups;
}
