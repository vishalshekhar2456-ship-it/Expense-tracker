import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:expenseful/app/theme.dart';
import 'package:expenseful/core/constants/category_visuals.dart';
import 'package:expenseful/data/database.dart';
import 'package:expenseful/providers/categories_provider.dart';
import 'package:expenseful/providers/currency_provider.dart';
import 'package:expenseful/providers/database_provider.dart';
import 'package:expenseful/providers/expenses_provider.dart';
import 'package:expenseful/providers/settings_provider.dart';

class ExpenseHistoryWidget extends ConsumerWidget {
  const ExpenseHistoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);
    final categoriesById = {
      for (final c in ref.watch(categoriesProvider).value ?? <Category>[])
        c.id: c,
    };
    final currencySymbol = ref.watch(currencySymbolProvider);
    final dateFormat =
        ref.watch(settingsProvider).value?.dateFormat ?? 'dd/MM/yyyy';

    return expensesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Something went wrong.')),
      data: (expenses) {
        if (expenses.isEmpty) {
          return const Center(child: Text('No expenses yet.'));
        }

        return ListView.separated(
          itemCount: expenses.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final expense = expenses[index];
            final category = categoriesById[expense.categoryId];
            final color = categoryColor(category?.color);
            final icon = categoryIcon(category?.icon);

            return Dismissible(
              key: ValueKey(expense.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: AppColors.coral.withValues(alpha: 0.12),
                child: const Icon(Icons.delete_outline, color: AppColors.coral),
              ),
              onDismissed: (_) async {
                final db = ref.read(appDatabaseProvider);
                await db.deleteExpense(expense.id);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('${expense.merchant} deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () => db.restoreExpense(expense.id),
                      ),
                    ),
                  );
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () => context.push('/edit_expense', extra: expense),
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.12),
                  child: Icon(icon, color: color, size: 20),
                ),
                title: Text(
                  expense.merchant,
                  style: AppTypography.bodyMedium,
                ),
                subtitle: Text(DateFormat(dateFormat).format(expense.date)),
                trailing: Text(
                  '$currencySymbol${expense.amount.toStringAsFixed(2)}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
