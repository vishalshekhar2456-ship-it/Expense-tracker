import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:expenseful/core/constants/currencies.dart';
import 'package:expenseful/app/theme.dart';
import 'package:expenseful/providers/settings_provider.dart';
import 'package:expenseful/providers/settings_repository_provider.dart';

class CurrencyPickerSheet extends ConsumerWidget {
  const CurrencyPickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
      ),
      builder: (_) => const CurrencyPickerSheet(),
    );
  }

  String _symbolFor(String code) =>
      NumberFormat.simpleCurrency(name: code).currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return SafeArea(
      child: settingsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child:
              Text('Could not load settings', style: AppTypography.bodyRegular),
        ),
        data: (settings) => ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child:
                  Text('Default currency', style: AppTypography.displayMedium),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final currency in kSupportedCurrencies)
              ListTile(
                leading: Text(
                  _symbolFor(currency.code),
                  style: AppTypography.numericMedium,
                ),
                title: Text(currency.name, style: AppTypography.bodyRegular),
                subtitle: Text(
                  currency.code,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.plumInk.withValues(alpha: 0.6),
                  ),
                ),
                trailing: currency.code == settings.currencyCode
                    ? const Icon(Icons.check, color: AppColors.plumInk)
                    : null,
                onTap: () async {
                  await ref
                      .read(settingsRepositoryProvider)
                      .updateCurrency(currency.code);
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}
