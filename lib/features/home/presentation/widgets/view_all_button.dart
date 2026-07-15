import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';
import 'package:expenseful/features/history/presentation/expense_history.dart'; // adjust to actual path

class ViewAllButton extends StatelessWidget {
  const ViewAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Expense History'),
                ),
                body: const ExpenseHistoryWidget(),
              ),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 4),
          side: BorderSide(color: AppColors.plumInk.withValues(alpha: 0.15)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.chip),
          ),
        ),
        child: Text(
          'View Full History',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.grape),
        ),
      ),
    );
  }
}