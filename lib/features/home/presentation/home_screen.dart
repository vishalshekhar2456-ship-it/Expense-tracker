import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';

// widgets imports
import 'widgets/tip_banner.dart';
import 'widgets/view_all_button.dart';
import 'widgets/recent_activity.dart';
import 'widgets/balance_card.dart';
import 'widgets/budget_card.dart';
import 'widgets/welcome_card.dart';
import 'widgets/top_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: const [
            TopBar(),
            SizedBox(height: AppSpacing.lg),
            WelcomeHeader(),
            SizedBox(height: AppSpacing.lg),
            BalanceCard(),
            SizedBox(height: AppSpacing.lg),
            BudgetCard(),
            SizedBox(height: AppSpacing.lg),
            RecentActivityCard(),
            SizedBox(height: AppSpacing.md),
            ViewAllButton(),
            SizedBox(height: AppSpacing.lg),
             TipBanner(),
            SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

