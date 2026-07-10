import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';
// ---------- Save bar ----------

class SaveBar extends StatelessWidget {
  final VoidCallback onSave;
  const SaveBar({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.paperBackground,
        border: Border(
            top: BorderSide(color: AppColors.plumInk.withValues(alpha: 0.06))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.grape,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.chip),
            ),
          ),
          child: Text(
            'Save Expense',
            style: AppTypography.bodyRegular.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
