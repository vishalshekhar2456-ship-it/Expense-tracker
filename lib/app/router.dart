import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Route path constants — reference these instead of hardcoding path
/// strings across the app.
class AppRoutes {
  AppRoutes._();

  static const welcome = '/welcome';
  static const currencySetup = '/currency-setup';
  static const home = '/';
  static const history = '/history';
  static const insights = '/insights';
  static const settings = '/settings';

  // Sheets are pushed as routes so they're deep-linkable / back-button aware,
  // rather than shown via showModalBottomSheet in isolation.
  static const addExpense = '/add-expense';
  static const expenseDetail = '/expense/:id';
  static const recurringConfirm = '/recurring-confirm/:ruleId';
  static const export = '/export';
}

/// Placeholder screens — replace each with the real feature screen as it's
/// built. Kept here so the router compiles standalone during scaffolding.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(label)));
  }
}

/// Builds the app's router.
///
/// TODO: once onboarding/auth state is wired up via Riverpod, add a
/// `redirect:` callback here to gate [AppRoutes.welcome] /
/// [AppRoutes.currencySetup] behind a "has completed onboarding" flag
/// (stored in AppSettings, not auth — sign-in remains optional).
GoRouter buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const _PlaceholderScreen('Welcome'),
      ),
      GoRoute(
        path: AppRoutes.currencySetup,
        builder: (context, state) =>
            const _PlaceholderScreen('Currency setup'),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const _PlaceholderScreen('Home'),
        routes: [
          GoRoute(
            path: 'add-expense',
            parentNavigatorKey: null,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: _PlaceholderScreen('Add Expense sheet'),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => const _PlaceholderScreen('History'),
      ),
      GoRoute(
        path: AppRoutes.insights,
        builder: (context, state) => const _PlaceholderScreen('Insights'),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const _PlaceholderScreen('Settings'),
      ),
    ],
  );
}
