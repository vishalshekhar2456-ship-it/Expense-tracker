import 'package:expenseful/features/settings/presentation/screen.dart';
import 'package:go_router/go_router.dart';
import 'package:expenseful/features/home/presentation/home_screen.dart';

import 'package:expenseful/features/add_expense/presentation/add_expense_screen.dart';
import 'package:expenseful/features/edit_expense/presentation/edit_expense_screen.dart';
import 'package:expenseful/data/database.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/add_expense',
      name: 'AddExpense',
      builder: (context, state) => const AddExpenseScreen(),
    ),
    GoRoute(
      path: '/edit_expense',
      name: 'EditExpense',
      builder: (context, state) =>
          EditExpenseScreen(expense: state.extra as Expense),
    )
  ],
);
