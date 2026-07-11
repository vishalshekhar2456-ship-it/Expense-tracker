import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';
import 'app/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  runApp(const ProviderScope(child: ExpensefulApp()));
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