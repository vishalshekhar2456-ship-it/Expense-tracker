import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';
import 'app/router.dart';


void main() {
  runApp(const ExpensefulApp());
}


class ExpensefulApp extends StatelessWidget {
  const ExpensefulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'expenseful',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(AppThemeVariant.warm),
      routerConfig: router,
    );
  }
}