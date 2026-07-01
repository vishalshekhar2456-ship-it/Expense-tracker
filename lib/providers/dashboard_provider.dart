import 'package:flutter/material.dart';

import '../models/account_summary.dart';
import '../models/savings_tip.dart';
import '../models/transaction_model.dart';

class DashboardProvider extends ChangeNotifier {
  bool isLoading = false;

  late SavingsTip savingsTip;

  final List<TransactionModel> transactions = [];

  DashboardProvider() {
    loadDashboard();
  }

  /// -------------------------
  /// Computed Summary
  /// -------------------------

  double get totalIncome => transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalBalance => totalIncome - totalExpense;

  AccountSummary get summary => AccountSummary(
        totalBalance: totalBalance,
        income: totalIncome,
        expense: totalExpense,
      );

  /// -------------------------
  /// Load Initial Data
  /// -------------------------

  Future<void> loadDashboard() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

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

  /// -------------------------
  /// Add Expense
  /// -------------------------

  void addExpense({
    required String title,
    required String category,
    required double amount,
  }) {
    transactions.insert(
      0,
      TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        category: category,
        date: DateTime.now(),
        amount: amount,
        isIncome: false,
      ),
    );

    notifyListeners();
  }

  /// -------------------------
  /// Add Income
  /// -------------------------

  void addIncome({
    required String title,
    required String category,
    required double amount,
  }) {
    transactions.insert(
      0,
      TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        category: category,
        date: DateTime.now(),
        amount: amount,
        isIncome: true,
      ),
    );

    notifyListeners();
  }

  /// -------------------------
  /// Delete Transaction
  /// -------------------------

  void deleteTransaction(int id) {
    transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();
  }

  /// -------------------------
  /// Clear All Transactions
  /// -------------------------

  void clearTransactions() {
    transactions.clear();
    notifyListeners();
  }
}