import 'package:flutter/material.dart';
import '../constants/colors.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar / logo placeholder
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.black,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Take Control of Your Finances',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Simple expense tracking to help you save more. '
          'Join thousands of users who have transformed their '
          'spending habits into wealth.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.grey,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}