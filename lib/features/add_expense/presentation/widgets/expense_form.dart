import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';
import 'input_field.dart';

class FormCard extends StatelessWidget {
  final TextEditingController merchantController;
  final TextEditingController notesController;
  final String date;
  final VoidCallback onDateTap;

  const FormCard({
    super.key,
    required this.merchantController,
    required this.notesController,
    required this.date,
    required this.onDateTap,
  });

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
          const _FieldLabel('Merchant Name'),
          const SizedBox(height: AppSpacing.xs),
          InputField(
            controller: merchantController,
            hint: 'e.g. Starbucks, Amazon, Blinkit',
            icon: Icons.storefront_rounded,
          ),
          const SizedBox(height: AppSpacing.md),
          const _FieldLabel('Date'),
          const SizedBox(height: AppSpacing.xs),
          InkWell(
            onTap: onDateTap,
            borderRadius: BorderRadius.circular(AppRadii.chip),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 4, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadii.chip),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 18,
                      color: AppColors.plumInk.withValues(alpha: 0.5)),
                  const SizedBox(width: AppSpacing.sm),
                  Text(date,
                      style: AppTypography.bodyRegular.copyWith(fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _FieldLabel('Notes (optional)'),
          const SizedBox(height: AppSpacing.xs),
          InputField(
            controller: notesController,
            hint: 'Add a note...',
            icon: Icons.notes_rounded,
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodyMedium.copyWith(
        fontSize: 13,
        color: AppColors.plumInk.withValues(alpha: 0.6),
      ),
    );
  }
}
