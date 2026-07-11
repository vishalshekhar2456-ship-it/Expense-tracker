import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';
import '../../../../core/constants/categories.dart';

class CategoryTile extends StatelessWidget {
  final CategoryOption category;
  final bool selected;
  final VoidCallback onTap;

  const CategoryTile(
      {super.key,
      required this.category,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? category.color : AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.card),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : AppColors.plumInk.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category.icon,
                size: 20,
                color: selected
                    ? Colors.white
                    : AppColors.plumInk.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 4),
              Text(
                category.label,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 12,
                  color: selected ? Colors.white : AppColors.plumInk,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
