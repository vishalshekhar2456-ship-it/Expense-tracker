import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'app_card.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double growth;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.growth,
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

          const SizedBox(height: 12),

          Text(
            "\$${balance.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: AppColors.success,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "+${growth.toStringAsFixed(1)}%",
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.account_balance_wallet_outlined,
                size: 34,
                color: AppColors.grey,
              )
            ],
          ),
        ],
      ),
    );
  }
}