import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../core/widgets/app_card.dart';

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({
    super.key,
    this.month = 'July',
    this.spent = 18420,
    this.budget = 25000,
  });

  final double spent;
  final double budget;
  final String month;

  @override
  Widget build(BuildContext context) {
    final progress = (spent / budget).clamp(0.0, 1.0);
    final remaining = budget - spent;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$month Spending',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            '₹${spent.toStringAsFixed(0)}',
            style: AppTypography.numericLarge,
          ),

          const SizedBox(height: AppSpacing.md),

          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.chip),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: const AlwaysStoppedAnimation(
                AppColors.teal,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).round()}% of budget used',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '₹${remaining.toStringAsFixed(0)} left',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Expense'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.bar_chart_rounded),
                  label: const Text('Insights'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}