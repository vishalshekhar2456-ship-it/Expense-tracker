import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';


class ViewAllButton extends StatelessWidget {
  const ViewAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 4),
          side: BorderSide(color: AppColors.plumInk.withOpacity(0.15)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.chip),
          ),
        ),
        child: Text(
          'View Full History',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.grape),
        ),
      ),
    );
  }
}
