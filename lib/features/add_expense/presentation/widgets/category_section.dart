import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';
import 'category_tile.dart';
import '/data/models/categories.dart';

class CategorySection extends StatelessWidget {
  final List<CategoryOption> categories;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  const CategorySection({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Select Category',
                style: AppTypography.displayMedium.copyWith(fontSize: 15)),
            const Spacer(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                'Manage Categories',
                style: AppTypography.bodyMedium
                    .copyWith(fontSize: 13, color: AppColors.grape),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 2.6,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            final selected = selectedIndex == index;
            return CategoryTile(
              category: category,
              selected: selected,
              onTap: () => onSelect(index),
            );
          },
        ),
      ],
    );
  }
}
