import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../providers/dashboard_provider.dart';
import 'package:expense_tracker/widgets/balanace_card.dart';
import 'package:expense_tracker/widgets/income_expense_seection.dart';
import 'package:expense_tracker/widgets/dashboard_header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              const DashboardHeader(),

              const SizedBox(height: 24),

              BalanceCard(
                balance: provider.summary.totalBalance,
                growth: provider.summary.growth,
              ),

              const SizedBox(height: 18),

              IncomeExpenseSection(
                income: provider.summary.income,
                expense: provider.summary.expense,
              ),
            ],
          ),
        ),
      ),
    );
  }
}