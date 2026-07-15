import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:expenseful/app/theme.dart';
import 'package:expenseful/core/budget_period.dart';
import 'package:expenseful/data/database.dart';
import 'package:expenseful/providers/currency_provider.dart';
import 'package:expenseful/providers/expenses_provider.dart';
import 'package:expenseful/providers/settings_provider.dart';

/// Dashboard overall-budget summary. Tapping opens the full Budgets screen.
class BudgetCard extends ConsumerWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value;
    final currencySymbol = ref.watch(currencySymbolProvider);
    final expenses = ref.watch(expensesProvider).value ?? const <Expense>[];

    final budget = settings?.monthlyBudget;
    final hasBudget = budget != null && budget > 0;

    final period =
        currentBudgetPeriod(DateTime.now(), settings?.budgetResetDay ?? 1);
    final spend = expenses
        .where((e) =>
            !e.date.isBefore(period.start) && e.date.isBefore(period.end))
        .fold(0.0, (sum, e) => sum + e.amount);

    final ratio = hasBudget ? (spend / budget).clamp(0.0, 1.0) : 0.0;
    final over = hasBudget && spend > budget;
    final barColor = over ? AppColors.coral : AppColors.grape;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.card),
      onTap: () => context.push('/budgets'),
      child: Container(
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
                Icon(Icons.local_fire_department_rounded,
                    size: 16, color: barColor),
                const SizedBox(width: AppSpacing.xs),
                Text('Budget Used', style: AppTypography.bodyMedium),
                const Spacer(),
                if (hasBudget)
                  Text(
                    '$currencySymbol${spend.toStringAsFixed(0)} / '
                    '$currencySymbol${budget.toStringAsFixed(0)}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.plumInk.withValues(alpha: 0.6),
                    ),
                  )
                else
                  Text(
                    'Set a budget',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.grape),
                  ),
              ],
            ),
            if (hasBudget) ...[
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.chip),
                child: LinearProgressIndicator(
                  value: ratio.toDouble(),
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceMuted,
                  valueColor: AlwaysStoppedAnimation(barColor),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                over
                    ? 'Over budget by '
                        '$currencySymbol${(spend - budget).toStringAsFixed(2)}'
                    : '${(ratio * 100).toStringAsFixed(0)}% of budget used',
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 11,
                  color: over
                      ? AppColors.coral
                      : AppColors.plumInk.withValues(alpha: 0.45),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
