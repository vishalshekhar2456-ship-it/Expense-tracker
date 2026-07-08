import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

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
          Row(
            children: [
              Text(
                'SPENT THIS MONTH',
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 12,
                  letterSpacing: 0.6,
                  color: AppColors.plumInk.withOpacity(0.5),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                ),
                child: Text(
                  '-12%',
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 12,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('₹4,210.00', style: AppTypography.numericLarge),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _PrimaryPillButton(
                  icon: Icons.add_rounded,
                  label: 'Add Expense',
                  filled: true,
                  onTap: () {},
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

