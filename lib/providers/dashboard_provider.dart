import 'package:flutter/material.dart';

import '../models/account_summary.dart';
import '../models/savings_tip.dart';
import '../models/transaction_model.dart';

class DashboardProvider extends ChangeNotifier {
  bool isLoading = false;

  late AccountSummary summary;

  late SavingsTip savingsTip;

  final List<TransactionModel> transactions = [];

  DashboardProvider() {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

    summary = const AccountSummary(
      totalBalance: 4250,
      income: 3500,
      expense: 1250,
      growth: 2.4,
    );

    savingsTip = const SavingsTip(
      title: "Smart Savings",
      description:
          "You've spent 15% less on dining this month. Great job!",
    );

    transactions.clear();

    transactions.addAll([
      TransactionModel(
        id: 1,
        title: "Grocery Shopping",
        category: "Food",
        date: DateTime.now(),
        amount: 120.75,
        isIncome: false,
      ),
      TransactionModel(
        id: 2,
        title: "Salary",
        category: "Income",
        date: DateTime.now(),
        amount: 3500,
        isIncome: true,
      ),
      TransactionModel(
        id: 3,
        title: "Netflix",
        category: "Subscription",
        date: DateTime.now(),
        amount: 15.99,
        isIncome: false,
      ),
    ]);

    isLoading = false;
    notifyListeners();
  }
}