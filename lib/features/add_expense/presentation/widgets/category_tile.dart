import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';
import 'package:expenseful/data/database.dart';
import 'package:expenseful/core/constants/category_visuals.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final bool selected;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(category.color);

    return Material(
      color: selected ? color : AppColors.surface,
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
                categoryIcon(category.icon),
                size: 20,
                color: selected
                    ? Colors.white
                    : AppColors.plumInk.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 4),
              Text(
                category.name,
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