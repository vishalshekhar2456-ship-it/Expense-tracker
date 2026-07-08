import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';

class TipBanner extends StatelessWidget {
  const TipBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.grape,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TIP',
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 11,
                    letterSpacing: 0.6,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Text(
                  'Set up recurring expenses to auto-log rent & subscriptions',
                  style: AppTypography.bodyRegular.copyWith(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}//