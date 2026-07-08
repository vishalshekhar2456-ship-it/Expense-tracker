import 'package:flutter/material.dart';

import '../../../../app/theme.dart';

class OverviewMetricTile extends StatelessWidget {
  const OverviewMetricTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                (iconColor ?? theme.colorScheme.primary).withOpacity(0.12),
            child: Icon(
              icon,
              size: 20,
              color: iconColor ?? theme.colorScheme.primary,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: AppTypography.numericMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}