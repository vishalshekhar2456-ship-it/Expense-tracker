import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/balanace_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/income_expense_seection.dart';
import 'add_transaction_screen.dart';

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

    final horizontalPadding =
        MediaQuery.sizeOf(context).width > 600 ? 32.0 : 20.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddTransactionScreen(
                isIncome: false,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),

              // const SizedBox(height: 24),

              BalanceCard(
                balance: provider.summary.totalBalance,
              ),

              const SizedBox(height: 8),

              IncomeExpenseSection(
                income: provider.summary.income,
                expense: provider.summary.expense,
              ),

              const SizedBox(height: 32),

              const Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: provider.transactions.isEmpty
                    ? const Center(
                        child: Text(
                          "No transactions yet.",
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: provider.transactions.length,
                        itemBuilder: (context, index) {
                          final transaction =
                              provider.transactions[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: transaction.isIncome
                                    ? Colors.green
                                    : Colors.red,
                                child: Icon(
                                  transaction.isIncome
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(transaction.title),
                              subtitle: Text(transaction.category),
                              trailing: Text(
                                "${transaction.isIncome ? "+" : "-"}"
                                "${transaction.amount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: transaction.isIncome
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}