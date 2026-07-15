import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;

  const InputField(
      {super.key,
      required this.controller,
      required this.hint,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: TextField(
        controller: controller,
        stylusHandwritingEnabled: false,
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
    );
  }
}
