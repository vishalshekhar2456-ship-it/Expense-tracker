import 'package:flutter/material.dart';
import '../constants/colors.dart';

class TrustCard extends StatelessWidget {
  const TrustCard({super.key});

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
          // Avatar row
          Row(
            children: [
              ...List.generate(
                  3,
                  (i) => Transform.translate(
                        offset: Offset(i * -10.0, 0),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: [
                            const Color(0xFFD1D5DB),
                            const Color(0xFF9CA3AF),
                            const Color(0xFF6B7280),
                          ][i],
                          child: Icon(Icons.person,
                              size: 18, color: AppColors.white),
                        ),
                      )),
              Transform.translate(
                offset: const Offset(-30, 0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.black,
                  child: const Text('10k+',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Trusted by 10,000+',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              )),
          const SizedBox(height: 4),
          const Text('Users trust us with their financial future.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey,
              )),
        ],
      ),
    );
  }
}