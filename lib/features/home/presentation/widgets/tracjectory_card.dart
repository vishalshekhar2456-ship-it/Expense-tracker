import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';

class TrajectoryCard extends StatelessWidget {
  const TrajectoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Monthly Trajectory', style: AppTypography.displayMedium.copyWith(fontSize: 16)),
          const SizedBox(height: AppSpacing.md),
          const _ProgressRow(
            icon: Icons.local_fire_department_rounded,
            label: 'Budget Used',
            value: '₹4,210 / ₹6,200',
            progress: 0.68,
            color: AppColors.coral,
            footnote: '68% of budget used',
          ),
          const SizedBox(height: AppSpacing.md),
          const _ProgressRow(
            icon: Icons.savings_outlined,
            label: 'Savings Goal',
            value: '₹12,400 saved',
            progress: 0.42,
            color: AppColors.teal,
            footnote: '42% toward ₹30k target',
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final double progress;
  final Color color;
  final String footnote;

  const _ProgressRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
    required this.footnote,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(label, style: AppTypography.bodyMedium),
            const Spacer(),
            Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.plumInk.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.chip),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.surfaceMuted,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          footnote,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 11,
            color: AppColors.plumInk.withOpacity(0.45),
          ),
        ),
      ],
    );
  }
}
