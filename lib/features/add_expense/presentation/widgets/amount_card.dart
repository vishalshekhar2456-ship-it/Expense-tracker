import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expenseful/app/theme.dart';
import 'package:expenseful/core/widgets/app_text_field.dart';
import 'package:expenseful/providers/currency_provider.dart';

class AmountCard extends ConsumerWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  const AmountCard({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencySymbol = ref.watch(currencySymbolProvider);
    final hasError = errorText != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: hasError ? Border.all(color: AppColors.coral) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Amount',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.plumInk.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                currencySymbol,
                style: AppTypography.numericLarge.copyWith(color: AppColors.grape),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: AppTextField(
                  controller: controller,
                  onChanged: onChanged,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: AppTypography.numericLarge,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          if (hasError) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              errorText!,
              style: AppTypography.bodyMedium
                  .copyWith(fontSize: 12, color: AppColors.coral),
            ),
          ],
        ],
      ),
    );
  }
}