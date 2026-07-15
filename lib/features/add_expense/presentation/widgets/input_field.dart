import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';
import 'package:expenseful/core/widgets/app_text_field.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const InputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadii.chip),
            border: hasError ? Border.all(color: AppColors.coral) : null,
          ),
          child: AppTextField(
            controller: controller,
            onChanged: onChanged,
            style: AppTypography.bodyRegular.copyWith(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodyRegular.copyWith(
                fontSize: 14,
                color: AppColors.plumInk.withValues(alpha: 0.35),
              ),
              prefixIcon: Icon(icon,
                  size: 18, color: AppColors.plumInk.withValues(alpha: 0.5)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 14, horizontal: AppSpacing.sm),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: AppSpacing.xs),
            child: Text(
              errorText!,
              style: AppTypography.bodyMedium
                  .copyWith(fontSize: 12, color: AppColors.coral),
            ),
          ),
      ],
    );
  }
}
