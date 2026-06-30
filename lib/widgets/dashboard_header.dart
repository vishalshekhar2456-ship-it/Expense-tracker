import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Welcome Back 👋",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 4),

            Text(
              "SpendWise",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),

        const Spacer(),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),

        const CircleAvatar(
          radius: 20,
          child: Icon(Icons.person),
        ),
      ],
    );
  }
}