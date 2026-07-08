import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';


class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _ActivityItem('Coffee & Snacks', 'Today, 09:12', -12.50, AppColors.marigold, Icons.local_cafe_rounded),
      _ActivityItem('Groceries', 'Yesterday', -149.99, AppColors.teal, Icons.shopping_cart_rounded),
      _ActivityItem('Cloud Storage', 'Jan 22', -8.20, AppColors.sky, Icons.cloud_rounded),
      _ActivityItem('Refund · Travel', 'Jan 20', 85.00, AppColors.grape, Icons.flight_rounded),
    ];

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
                Icon(Icons.receipt_rounded, size: 18, color: AppColors.plumInk.withOpacity(0.7)),
                const SizedBox(width: AppSpacing.xs),
                Text('Recent Activity', style: AppTypography.displayMedium.copyWith(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (int i = 0; i < items.length; i++) ...[
            _ActivityRow(item: items[i]),
            if (i != items.length - 1)
              Divider(height: 1, indent: 52, color: AppColors.plumInk.withOpacity(0.06)),
          ],
        ],
      ),
    );
  }
}

class _ActivityItem {
  final String label;
  final String subtitle;
  final double amount;
  final Color color;
  final IconData icon;

  _ActivityItem(this.label, this.subtitle, this.amount, this.color, this.icon);
}

class _ActivityRow extends StatelessWidget {
  final _ActivityItem item;
  const _ActivityRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final isPositive = item.amount > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppRadii.card / 2),
            ),
            child: Icon(item.icon, size: 18, color: item.color),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label, style: AppTypography.bodyRegular.copyWith(fontSize: 14)),
                Text(
                  item.subtitle,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 11,
                    color: AppColors.plumInk.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : '-'}₹${item.amount.abs().toStringAsFixed(2)}',
            style: AppTypography.numericMedium.copyWith(
              fontSize: 14,
              color: isPositive ? AppColors.success : AppColors.plumInk,
            ),
          ),
        ],
      ),
    );
  }
}

