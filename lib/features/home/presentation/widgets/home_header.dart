import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.userName = 'Alex',
    this.greeting = 'Good Morning',
  });

  final String userName;
  final String greeting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back, $userName 👋',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 6),
              Text(
                "Let's keep your finances on track today.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        /// Notifications
        IconButton(
          onPressed: () {
          },
          icon: const Icon(Icons.notifications_none_rounded),
        ),

        const SizedBox(width: 8),

        /// Avatar
        CircleAvatar(
          radius: 22,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            userName.characters.first.toUpperCase(),
            style: theme.textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}