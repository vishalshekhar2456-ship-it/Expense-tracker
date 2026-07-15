import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:expenseful/app/theme.dart';
import 'package:expenseful/core/constants/category_visuals.dart';
import 'package:expenseful/data/database.dart';
import 'package:expenseful/providers/categories_provider.dart';
import 'package:expenseful/providers/currency_provider.dart';
import 'package:expenseful/providers/expenses_provider.dart';
import 'package:expenseful/providers/settings_provider.dart';

/// Number of recent expenses to preview on the dashboard.
const _kRecentLimit = 5;

class RecentActivityCard extends ConsumerWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);
    final categoriesById = {
      for (final c in ref.watch(allCategoriesProvider).value ?? <Category>[])
        c.id: c,
    };
    final currencySymbol = ref.watch(currencySymbolProvider);
    final dateFormat =
        ref.watch(settingsProvider).value?.dateFormat ?? 'dd/MM/yyyy';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Row(
              children: [
                Icon(Icons.receipt_rounded,
                    size: 18, color: AppColors.plumInk.withValues(alpha: 0.7)),
                const SizedBox(width: AppSpacing.xs),
                Text('Recent Activity',
                    style: AppTypography.displayMedium.copyWith(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          expensesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Text('Something went wrong.'),
            ),
            data: (expenses) {
              if (expenses.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Center(
                    child: Text(
                      'No expenses yet.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.plumInk.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                );
              }

              final recent = expenses.take(_kRecentLimit).toList();
              return Column(
                children: [
                  for (int i = 0; i < recent.length; i++) ...[
                    _ActivityRow(
                      expense: recent[i],
                      category: categoriesById[recent[i].categoryId],
                      currencySymbol: currencySymbol,
                      dateFormat: dateFormat,
                    ),
                    if (i != recent.length - 1)
                      Divider(
                        height: 1,
                        indent: 52,
                        color: AppColors.plumInk.withValues(alpha: 0.06),
                      ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final Expense expense;
  final Category? category;
  final String currencySymbol;
  final String dateFormat;

  const _ActivityRow({
    required this.expense,
    required this.category,
    required this.currencySymbol,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(category?.color);
    final icon = categoryIcon(category?.icon);

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.card / 2),
      onTap: () => context.push('/edit_expense', extra: expense),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadii.card / 2),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expense.merchant,
                      style: AppTypography.bodyRegular.copyWith(fontSize: 14)),
                  Text(
                    DateFormat(dateFormat).format(expense.date),
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 11,
                      color: AppColors.plumInk.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '-$currencySymbol${expense.amount.toStringAsFixed(2)}',
              style: AppTypography.numericMedium.copyWith(
                fontSize: 14,
                color: AppColors.plumInk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
