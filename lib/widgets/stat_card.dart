import 'package:flutter/material.dart';
import '../constants/colors.dart';

class StatCard extends StatelessWidget {
  const StatCard({super.key, 
    required this.icon,
    required this.iconColor,
    required this.headline,
    required this.body,
  });

  final IconData icon;
  final Color iconColor;
  final String headline;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(headline,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              )),
          const SizedBox(height: 4),
          Text(body,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey,
              )),
        ],
      ),
    );
  }
}