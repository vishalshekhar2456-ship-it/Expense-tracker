import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'app_card.dart';

class BalanceCard extends StatelessWidget {
  final double balance;

  const BalanceCard({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Total Balance",
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 15,
            ),
          ),


          Text(
            balance.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}