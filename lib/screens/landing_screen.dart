import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/hero_section.dart';
import 'package:expense_tracker/widgets/login_link.dart';
import 'package:expense_tracker/widgets/signup_button.dart';
import 'package:expense_tracker/widgets/stat_card.dart';
import 'package:expense_tracker/widgets/trust_card.dart';
import '../constants/colors.dart';
import '../services/auth_service.dart';
import 'package:expense_tracker/screens/dashboard_screen.dart';

// ── Landing Screen ───────────────────────────────────
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  static const _bg = AppColors.background;

  @override
  Widget build(BuildContext context) {
    final authService = AuthService(); // ✅ correct placement

    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Hero section
            const HeroSection(),

            const SizedBox(height: 40),

            // Phone signup button
            SignUpButton(
  label: 'Sign up with Phone Number',
  icon: Icons.phone_android,
  filled: true,
  onTap: () {
    // Phone auth
  },
),

const SizedBox(height: 12),

SignUpButton(
  label: 'Google',
  isGoogle: true,
  onTap: () async {
  try {
    debugPrint("Starting Google Sign-In...");

    final user = await authService.signInWithGoogle();

    debugPrint("Returned user: $user");

    if (!context.mounted) return;

    if (user != null) {
      debugPrint("Login successful.");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );
    } else {
      debugPrint("Google Sign-In returned null.");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Google Sign-In failed."),
        ),
      );
    }
  } catch (e, stackTrace) {
    debugPrint("Google Sign-In Exception: $e");
    debugPrint(stackTrace.toString());

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $e"),
      ),
    );
  }
},
),

            const SizedBox(height: 20),

            // Login link
            const LoginLink(),

            const SizedBox(height: 40),

            // Stat card
            const StatCard(
              icon: Icons.trending_up,
              iconColor: AppColors.success,
              headline: '85%',
              body: 'Average user savings in the first six months.',
            ),

            const SizedBox(height: 16),

            // Trust card
            const TrustCard(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      title: const Text(
        'SpendWise',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: AppColors.black,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.account_circle_outlined,
              color: AppColors.black),
          onPressed: () {},
        ),
      ],
    );
  }
}