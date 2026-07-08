import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome back, Vishal.', style: AppTypography.displayLarge.copyWith(fontSize: 24)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Your jar is filling up steadily this month.',
          style: AppTypography.bodyRegular.copyWith(
            color: AppColors.plumInk.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
