import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:expenseful/app/theme.dart';
import 'package:expenseful/core/constants/category_visuals.dart';
import 'package:expenseful/data/database.dart';
import 'package:expenseful/features/history/domain/history_filter.dart';
import 'package:expenseful/features/history/presentation/widgets/history_filter_bar.dart';
import 'package:expenseful/providers/categories_provider.dart';
import 'package:expenseful/providers/currency_provider.dart';
import 'package:expenseful/providers/database_provider.dart';
import 'package:expenseful/providers/expenses_provider.dart';
import 'package:expenseful/providers/settings_provider.dart';

class ExpenseHistoryWidget extends ConsumerStatefulWidget {
  const ExpenseHistoryWidget({super.key});

  @override
  ConsumerState<ExpenseHistoryWidget> createState() =>
      _ExpenseHistoryWidgetState();
}

class _ExpenseHistoryWidgetState extends ConsumerState<ExpenseHistoryWidget> {
  final _searchController = TextEditingController();
  var _filter = const HistoryFilter();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesProvider);
    final allCategories = ref.watch(allCategoriesProvider).value ?? <Category>[];
    final categoriesById = {for (final c in allCategories) c.id: c};
    final currencySymbol = ref.watch(currencySymbolProvider);
    final dateFormat =
        ref.watch(settingsProvider).value?.dateFormat ?? 'dd/MM/yyyy';

    // Categories that are still active drive the filter chips; archived ones
    // are kept in [categoriesById] only so old expenses still render.
    final filterCategories =
        allCategories.where((c) => !c.isArchived).toList();

    return expensesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Something went wrong.')),
      data: (expenses) {
        final filtered =
            expenses.where(_filter.matches).toList(growable: false);
        // Browsing everything reads best day-by-day; once a filter narrows
        // things down (and can span a wide range) months stay compact.
        final grouping = _filter.isActive
            ? HistoryGrouping.month
            : HistoryGrouping.day;
        final groups = groupExpenses(filtered, grouping);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: HistoryFilterBar(
                filter: _filter,
                categories: filterCategories,
                searchController: _searchController,
                onChanged: (next) => setState(() => _filter = next),
              ),
            ),
            Expanded(
              child: _buildList(
                expenses: expenses,
                groups: groups,
                categoriesById: categoriesById,
                currencySymbol: currencySymbol,
                dateFormat: dateFormat,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildList({
    required List<Expense> expenses,
    required List<ExpenseGroup> groups,
    required Map<String, Category> categoriesById,
    required String currencySymbol,
    required String dateFormat,
  }) {
    if (expenses.isEmpty) {
      return const _EmptyState(message: 'No expenses yet.');
    }
    if (groups.isEmpty) {
      return const _EmptyState(message: 'No expenses match your filters.');
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        final isDay = group.grouping == HistoryGrouping.day;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GroupHeader(
              label: _headerLabel(group),
              total: '$currencySymbol${group.total.toStringAsFixed(2)}',
            ),
            for (final expense in group.expenses)
              _ExpenseTile(
                expense: expense,
                category: categoriesById[expense.categoryId],
                currencySymbol: currencySymbol,
                // Under a day header the date is already shown, so surface the
                // category instead; month headers keep the per-tile date.
                showDate: !isDay,
                dateFormat: dateFormat,
              ),
          ],
        );
      },
    );
  }

  String _headerLabel(ExpenseGroup group) {
    if (group.grouping == HistoryGrouping.month) {
      return DateFormat('MMMM yyyy').format(group.period);
    }
    final today = DateUtils.dateOnly(DateTime.now());
    final diff = today.difference(group.period).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    final pattern =
        group.period.year == today.year ? 'EEEE, d MMM' : 'EEEE, d MMM yyyy';
    return DateFormat(pattern).format(group.period);
  }
}

class _GroupHeader extends StatelessWidget {
  final String label;
  final String total;

  const _GroupHeader({required this.label, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.plumInk.withValues(alpha: 0.7),
            ),
          ),
          const Spacer(),
          Text(
            total,
            style: AppTypography.numericMedium.copyWith(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _ExpenseTile extends ConsumerWidget {
  final Expense expense;
  final Category? category;
  final String currencySymbol;
  final bool showDate;
  final String dateFormat;

  const _ExpenseTile({
    required this.expense,
    required this.category,
    required this.currencySymbol,
    required this.showDate,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = categoryColor(category?.color);
    final icon = categoryIcon(category?.icon);
    // Day groups show the date in the header; fall back to it only when the
    // expense has no category to name.
    final subtitle = showDate
        ? DateFormat(dateFormat).format(expense.date)
        : (category?.name ?? DateFormat(dateFormat).format(expense.date));

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
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        onTap: () => context.push('/edit_expense', extra: expense),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(expense.merchant, style: AppTypography.bodyMedium),
        subtitle: Text(subtitle),
        trailing: Text(
          '$currencySymbol${expense.amount.toStringAsFixed(2)}',
          style: AppTypography.bodyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.bodyRegular.copyWith(
            color: AppColors.plumInk.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
