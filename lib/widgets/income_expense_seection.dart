import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'summary_card.dart';

class IncomeExpenseSection extends StatelessWidget {
  final double income;
  final double expense;

  const IncomeExpenseSection({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SummaryCard(
          title: "Income",
          amount: income,
          icon: Icons.arrow_downward,
          iconColor: AppColors.success,
        ),

        const SizedBox(width: 16),

        SummaryCard(
          title: "Expense",
          amount: expense,
          icon: Icons.arrow_upward,
          iconColor: Colors.red,
        ),
      ],
    );
  }
}