// Validation for the expense add/edit form. Shared by the add and edit screens
// so both surface identical, friendly error messages instead of silently
// refusing to save.

import 'package:expenseful/core/amount_formatter.dart';

/// Field-level error messages; a null field means that field is valid.
typedef ExpenseFormErrors = ({String? amount, String? merchant});

ExpenseFormErrors validateExpenseInput({
  required String amountText,
  required String merchantText,
}) {
  final trimmedAmount = amountText.trim();
  final amount = parseAmount(trimmedAmount);

  String? amountError;
  if (trimmedAmount.isEmpty) {
    amountError = 'Enter an amount';
  } else if (amount == null) {
    amountError = 'Enter a valid number';
  } else if (amount <= 0) {
    amountError = 'Amount must be greater than 0';
  }

  final merchantError =
      merchantText.trim().isEmpty ? 'Enter a merchant name' : null;

  return (amount: amountError, merchant: merchantError);
}
