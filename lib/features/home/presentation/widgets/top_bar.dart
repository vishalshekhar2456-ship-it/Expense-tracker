import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';
import 'package:go_router/go_router.dart';
// ---------- Top bar ----------

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.grape,
            borderRadius: BorderRadius.circular(AppRadii.card / 2),
          ),
          child:
              const Icon(Icons.savings_rounded, size: 18, color: Colors.white),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text('expenseful',
            style: AppTypography.displayMedium.copyWith(fontSize: 18)),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.settings_rounded,
              color: AppColors.plumInk.withValues(alpha: 0.7)),
          onPressed: () => context.push('/settings'),
        ),
      ],
    );
  }
}
