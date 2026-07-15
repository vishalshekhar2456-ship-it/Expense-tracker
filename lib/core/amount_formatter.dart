import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Live thousands-grouping for the amount field. Groups the integer part as the
/// user types (Indian lakh/crore style with `en_IN`, e.g. 12,34,567; Western
/// style otherwise, e.g. 1,234,567) while keeping up to two decimal places.
///
/// The stored text therefore contains commas — use [parseAmount] (which strips
/// them) whenever reading a numeric value back out.
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  /// Intl locale used for grouping. 'en_IN' gives lakh/crore grouping.
  final String locale;

  ThousandsSeparatorInputFormatter({this.locale = 'en_IN'});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    // Strip grouping and any stray characters, keep digits + dots.
    var cleaned = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Collapse to a single decimal point and cap decimals at two places.
    final firstDot = cleaned.indexOf('.');
    final hasDot = firstDot != -1;
    String intDigits;
    String? decDigits;
    if (hasDot) {
      intDigits = cleaned.substring(0, firstDot).replaceAll('.', '');
      decDigits = cleaned.substring(firstDot + 1).replaceAll('.', '');
      if (decDigits.length > 2) decDigits = decDigits.substring(0, 2);
    } else {
      intDigits = cleaned;
    }

    // Guard against int overflow on absurdly long input.
    if (intDigits.length > 15) return oldValue;

    final String groupedInt;
    if (intDigits.isEmpty) {
      // e.g. user typed ".5" -> show "0.5"
      groupedInt = hasDot ? '0' : '';
    } else {
      groupedInt = NumberFormat.decimalPattern(locale).format(int.parse(intDigits));
    }

    final result = hasDot ? '$groupedInt.$decDigits' : groupedInt;

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

/// Parses an amount string that may contain grouping commas.
double? parseAmount(String text) =>
    double.tryParse(text.replaceAll(',', '').trim());
