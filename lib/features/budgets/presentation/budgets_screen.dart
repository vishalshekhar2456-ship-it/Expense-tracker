import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expenseful/app/theme.dart';
import 'package:expenseful/core/budget_period.dart';
import 'package:expenseful/core/constants/category_visuals.dart';
import 'package:expenseful/data/database.dart';
import 'package:expenseful/providers/budgets_provider.dart';
import 'package:expenseful/providers/categories_provider.dart';
import 'package:expenseful/providers/currency_provider.dart';
import 'package:expenseful/providers/database_provider.dart';
import 'package:expenseful/providers/expenses_provider.dart';
import 'package:expenseful/providers/settings_provider.dart';
import 'package:expenseful/providers/settings_repository_provider.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value;
    final currencySymbol = ref.watch(currencySymbolProvider);
    final expenses = ref.watch(expensesProvider).value ?? const <Expense>[];
    final categories =
        ref.watch(categoriesProvider).value ?? const <Category>[];
    final budgetByCategory = {
      for (final b in ref.watch(budgetsProvider).value ?? <Budget>[])
        b.categoryId: b.amount,
    };

    // Spend within the current budget period, overall and per category.
    final period =
        currentBudgetPeriod(DateTime.now(), settings?.budgetResetDay ?? 1);
    final inPeriod = expenses.where(
      (e) => !e.date.isBefore(period.start) && e.date.isBefore(period.end),
    );
    var totalSpend = 0.0;
    final spendByCategory = <String, double>{};
    for (final e in inPeriod) {
      totalSpend += e.amount;
      if (e.categoryId != null) {
        spendByCategory[e.categoryId!] =
            (spendByCategory[e.categoryId!] ?? 0) + e.amount;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.paperBackground,
      appBar: AppBar(
        backgroundColor: AppColors.paperBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.plumInk),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Budgets', style: AppTypography.displayMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _OverallBudgetCard(
            spend: totalSpend,
            budget: settings?.monthlyBudget,
            currencySymbol: currencySymbol,
            onEdit: () => _editAmount(
              context: context,
              title: 'Overall monthly budget',
              current: settings?.monthlyBudget,
              currencySymbol: currencySymbol,
              onSave: (value) =>
                  ref.read(settingsRepositoryProvider).updateMonthlyBudget(value),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.only(
                left: AppSpacing.xs, bottom: AppSpacing.sm),
            child: Text(
              'PER-CATEGORY LIMITS',
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 12,
                letterSpacing: 0.6,
                color: AppColors.plumInk.withValues(alpha: 0.5),
              ),
            ),
          ),
          if (categories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(
                child: Text('No categories yet.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.plumInk.withValues(alpha: 0.45),
                    )),
              ),
            )
          else
            for (final category in categories)
              _CategoryBudgetRow(
                category: category,
                spend: spendByCategory[category.id] ?? 0,
                budget: budgetByCategory[category.id],
                currencySymbol: currencySymbol,
                onEdit: () => _editAmount(
                  context: context,
                  title: '${category.name} budget',
                  current: budgetByCategory[category.id],
                  currencySymbol: currencySymbol,
                  onSave: (value) async {
                    final db = ref.read(appDatabaseProvider);
                    if (value == null) {
                      await db.deleteBudget(category.id);
                    } else {
                      await db.setBudget(category.id, value);
                    }
                  },
                ),
              ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  /// Prompts for an amount; an empty value clears the budget (passes null).
  Future<void> _editAmount({
    required BuildContext context,
    required String title,
    required double? current,
    required String currencySymbol,
    required Future<void> Function(double? value) onSave,
  }) async {
    final controller = TextEditingController(
      text: (current != null && current > 0) ? current.toStringAsFixed(0) : '',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(title, style: AppTypography.displayMedium.copyWith(fontSize: 18)),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          decoration: InputDecoration(
            prefixText: '$currencySymbol ',
            hintText: 'Leave empty to remove',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final text = controller.text.trim();
    final parsed = double.tryParse(text);
    // Empty or non-positive clears the budget.
    await onSave((parsed == null || parsed <= 0) ? null : parsed);
  }
}

class _OverallBudgetCard extends StatelessWidget {
  final double spend;
  final double? budget;
  final String currencySymbol;
  final VoidCallback onEdit;

  const _OverallBudgetCard({
    required this.spend,
    required this.budget,
    required this.currencySymbol,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final hasBudget = budget != null && budget! > 0;
    final ratio = hasBudget ? (spend / budget!).clamp(0.0, 1.0) : 0.0;
    final over = hasBudget && spend > budget!;
    final barColor = over ? AppColors.coral : AppColors.grape;

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
              Text('Overall monthly budget',
                  style: AppTypography.displayMedium.copyWith(fontSize: 16)),
              const Spacer(),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded, size: 18),
                color: AppColors.grape,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          if (!hasBudget)
            TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Set a monthly budget'),
            )
          else ...[
            Text(
              '$currencySymbol${spend.toStringAsFixed(2)} '
              'of $currencySymbol${budget!.toStringAsFixed(2)}',
              style: AppTypography.numericMedium.copyWith(fontSize: 18),
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.chip),
              child: LinearProgressIndicator(
                value: ratio.toDouble(),
                minHeight: 8,
                backgroundColor: AppColors.surfaceMuted,
                valueColor: AlwaysStoppedAnimation(barColor),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              over
                  ? 'Over budget by '
                      '$currencySymbol${(spend - budget!).toStringAsFixed(2)}'
                  : '$currencySymbol${(budget! - spend).toStringAsFixed(2)} left',
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 12,
                color: over
                    ? AppColors.coral
                    : AppColors.plumInk.withValues(alpha: 0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryBudgetRow extends StatelessWidget {
  final Category category;
  final double spend;
  final double? budget;
  final String currencySymbol;
  final VoidCallback onEdit;

  const _CategoryBudgetRow({
    required this.category,
    required this.spend,
    required this.budget,
    required this.currencySymbol,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(category.color);
    final icon = categoryIcon(category.icon);
    final hasBudget = budget != null && budget! > 0;
    final ratio = hasBudget ? (spend / budget!).clamp(0.0, 1.0) : 0.0;
    final over = hasBudget && spend > budget!;

    return InkWell(
      onTap: onEdit,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(category.name, style: AppTypography.bodyMedium),
                      const Spacer(),
                      Text(
                        hasBudget
                            ? '$currencySymbol${spend.toStringAsFixed(0)} / '
                                '$currencySymbol${budget!.toStringAsFixed(0)}'
                            : 'Set',
                        style: AppTypography.bodyMedium.copyWith(
                          color: over
                              ? AppColors.coral
                              : AppColors.plumInk.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                  if (hasBudget) ...[
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                      child: LinearProgressIndicator(
                        value: ratio.toDouble(),
                        minHeight: 6,
                        backgroundColor: AppColors.surfaceMuted,
                        valueColor: AlwaysStoppedAnimation(
                            over ? AppColors.coral : color),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
