import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';
import 'package:expenseful/features/settings/presentation/screen.dart';
import 'package:go_router/go_router.dart';
import 'package:expenseful/features/home/presentation/home_screen.dart';


void main() {
  runApp(const ExpensefulApp());
}

final GoRouter _router = GoRouter(
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
  ],
);

class ExpensefulApp extends StatelessWidget {
  const ExpensefulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'expenseful',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(AppThemeVariant.warm),
      routerConfig: _router,
    );
  }
}