import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:expenseful/app/theme.dart';
import 'package:expenseful/data/database.dart';
import  'package:expenseful/providers/settings_provider.dart';
import 'package:expenseful/providers/currency_provider.dart';
import 'package:expenseful/providers/database_provider.dart';

class ExpenseHistoryWidget extends ConsumerWidget {
  const ExpenseHistoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(appDatabaseProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);
    final dateFormat = ref.watch(settingsProvider).value?.dateFormat ?? 'dd/MM/yyyy';

    return StreamBuilder<List<Category>>(
      stream: database.watchCategories(),
      builder: (context, categorySnapshot) {
        final categoriesById = {
          for (final c in categorySnapshot.data ?? <Category>[]) c.id: c,
        };

        return StreamBuilder<List<Expense>>(
          stream: database.watchExpenses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong.'));
            }

            final expenses = snapshot.data ?? [];

            if (expenses.isEmpty) {
              return const Center(child: Text('No expenses yet.'));
            }

            return ListView.separated(
              itemCount: expenses.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final expense = expenses[index];
                final category = categoriesById[expense.categoryId];
                final color = _categoryColor(category?.color);
                final icon = _categoryIcon(category?.icon);

                return ListTile(
                  contentPadding: EdgeInsets.zero,
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
                );
              },
            );
          },
        );
      },
    );
  }

  Color _categoryColor(String? color) {
    switch (color) {
      case 'coral':
        return AppColors.coral;
      case 'marigold':
        return AppColors.marigold;
      case 'teal':
        return AppColors.teal;
      case 'grape':
        return AppColors.grape;
      case 'sky':
        return AppColors.sky;
      case 'pink':
        return AppColors.pink;
      default:
        return AppColors.grape;
    }
  }

  IconData _categoryIcon(String? icon) {
    switch (icon) {
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'directions_car':
        return Icons.directions_car;
      case 'bolt':
        return Icons.bolt;
      case 'movie':
        return Icons.movie;
      case 'favorite':
        return Icons.favorite;
      default:
        return Icons.category;
    }
  }
}