import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'settings_provider.dart';

part 'currency_provider.g.dart';

/// Resolves the current currency code into a display symbol,
/// e.g. "INR" -> "₹", "USD" -> "$". Falls back to "₹" while settings
/// are still loading, since that's expenseful's default.
@riverpod
String currencySymbol(CurrencySymbolRef ref) {
  final settingsAsync = ref.watch(settingsProvider);

  return settingsAsync.when(
    data: (settings) {
      final format = NumberFormat.simpleCurrency(name: settings.currencyCode);
      return format.currencySymbol;
    },
    loading: () => '₹',
    error: (_, __) => '₹',
  );
}