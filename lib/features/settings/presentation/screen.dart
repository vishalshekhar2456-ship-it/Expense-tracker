import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperBackground,
      appBar: AppBar(
        backgroundColor: AppColors.paperBackground,
        elevation: 0,
        title: Text(
          'Settings',
          style: AppTypography.displayMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: const [
          _SettingsSection(
            title: 'Currency & Locale',
            items: [
              _SettingsItem(icon: Icons.attach_money_rounded, label: 'Default currency'),
              _SettingsItem(icon: Icons.calendar_today_rounded, label: 'Date format'),
            ],
          ),
          _SettingsSection(
            title: 'Categories & Tags',
            items: [
              _SettingsItem(icon: Icons.category_rounded, label: 'Manage categories'),
              _SettingsItem(icon: Icons.label_rounded, label: 'Manage tags'),
            ],
          ),
          _SettingsSection(
            title: 'Recurring Expenses',
            items: [
              _SettingsItem(icon: Icons.repeat_rounded, label: 'Manage recurring rules'),
            ],
          ),
          _SettingsSection(
            title: 'Budget & Insights',
            items: [
              _SettingsItem(icon: Icons.pie_chart_rounded, label: 'Monthly budget'),
            ],
          ),
          _SettingsSection(
            title: 'Appearance',
            items: [
              _SettingsItem(icon: Icons.palette_rounded, label: 'Theme'),
            ],
          ),
          _SettingsSection(
            title: 'Data & Backup',
            items: [
              _SettingsItem(icon: Icons.ios_share_rounded, label: 'Export data'),
            ],
          ),
          _SettingsSection(
            title: 'Security & Privacy',
            items: [
              _SettingsItem(icon: Icons.lock_rounded, label: 'App lock'),
            ],
          ),
          _SettingsSection(
            title: 'About & Support',
            items: [
              _SettingsItem(icon: Icons.info_outline_rounded, label: 'About expenseful'),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: 6),
            child: Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.plumInk.withValues(alpha: 0.55),
                fontSize: 13,
                letterSpacing: 0.4,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadii.card),
            ),
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  items[i],
                  if (i != items.length - 1)
                    Divider(
                      height: 1,
                      indent: AppSpacing.xxl + AppSpacing.xs,
                      endIndent: AppSpacing.md,
                      color: AppColors.plumInk.withValues(alpha: 0.08),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SettingsItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 4,
          vertical: AppSpacing.md - 2,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.plumInk.withValues(alpha: 0.75)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyRegular.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.plumInk.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
  }
}