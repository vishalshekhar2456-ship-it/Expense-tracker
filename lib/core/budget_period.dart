/// A half-open time window [start, end) for a budget cycle.
typedef BudgetPeriod = ({DateTime start, DateTime end});

/// Returns the current budget period for [now], given the configured
/// [resetDay] of the month (1-based). The window is half-open: an expense
/// belongs to the period when `start <= date < end`.
///
/// [resetDay] is clamped to 1..28 so the cycle start exists in every month
/// (avoids skipping in February / short months).
BudgetPeriod currentBudgetPeriod(DateTime now, int resetDay) {
  final day = resetDay.clamp(1, 28);

  final DateTime start;
  if (now.day >= day) {
    start = DateTime(now.year, now.month, day);
  } else {
    // Still in the cycle that began last month.
    start = DateTime(now.year, now.month - 1, day);
  }

  final end = DateTime(start.year, start.month + 1, start.day);
  return (start: start, end: end);
}
