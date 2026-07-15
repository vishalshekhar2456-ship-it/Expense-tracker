import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expenseful/app/theme.dart';
import 'package:go_router/go_router.dart';

import 'package:expenseful/data/database.dart';
import 'package:expenseful/providers/currency_provider.dart';
import 'package:expenseful/providers/expenses_provider.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  /// Sums the amounts of expenses whose date falls in [start, end).
  double _totalForRange(
      List<Expense> expenses, DateTime start, DateTime end) {
    return expenses
        .where((e) => !e.date.isBefore(start) && e.date.isBefore(end))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider).value ?? const <Expense>[];
    final currencySymbol = ref.watch(currencySymbolProvider);

    final now = DateTime.now();
    final thisMonthStart = DateTime(now.year, now.month, 1);
    final nextMonthStart = DateTime(now.year, now.month + 1, 1);
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);

    final thisMonthTotal =
        _totalForRange(expenses, thisMonthStart, nextMonthStart);
    final lastMonthTotal =
        _totalForRange(expenses, lastMonthStart, thisMonthStart);

    // Month-over-month change; only meaningful once there's a prior month.
    final double? changePct = lastMonthTotal > 0
        ? ((thisMonthTotal - lastMonthTotal) / lastMonthTotal) * 100
        : null;
    // Spending down (or flat) reads as positive/green; up reads as coral.
    final bool spendingUp = (changePct ?? 0) > 0;
    final changeColor = spendingUp ? AppColors.coral : AppColors.success;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'SPENT THIS MONTH',
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 12,
                  letterSpacing: 0.6,
                  color: AppColors.plumInk.withValues(alpha: 0.5),
                ),
              ),
              const Spacer(),
              if (changePct != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: changeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadii.chip),
                  ),
                  child: Text(
                    '${spendingUp ? '+' : '-'}${changePct.abs().toStringAsFixed(0)}%',
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 12,
                      color: changeColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('$currencySymbol${thisMonthTotal.toStringAsFixed(2)}',
              style: AppTypography.numericLarge),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _PrimaryPillButton(
                  icon: Icons.add_rounded,
                  label: 'Add Expense',
                  filled: true,
                  onTap:() => context.push('/add_expense'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _PrimaryPillButton(
                  icon: Icons.receipt_long_rounded,
                  label: 'Scan',
                  filled: false,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _PrimaryPillButton(
                  icon: Icons.ios_share_rounded,
                  label: 'Export',
                  filled: false,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrimaryPillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _PrimaryPillButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.grape : AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(AppRadii.chip),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.chip),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Icon(icon, size: 18, color: filled ? Colors.white : AppColors.plumInk),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 12,
                  color: filled ? Colors.white : AppColors.plumInk,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

