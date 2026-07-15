import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:expenseful/app/theme.dart';
import 'package:expenseful/data/database.dart';
import 'package:expenseful/providers/database_provider.dart';
import 'category_tile.dart';

class CategorySection extends ConsumerWidget {
  final String? selectedCategoryId;
  final ValueChanged<String> onSelect;

  const CategorySection({
    super.key,
    required this.selectedCategoryId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(appDatabaseProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Select Category',
                style: AppTypography.displayMedium.copyWith(fontSize: 15)),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/categories'),
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
        StreamBuilder<List<Category>>(
          stream: database.watchCategories(),
          builder: (context, snapshot) {
            final categories = snapshot.data ?? [];

            if (categories.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return GridView.builder(
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
                final selected = selectedCategoryId == category.id;
                return CategoryTile(
                  category: category,
                  selected: selected,
                  onTap: () => onSelect(category.id),
                );
              },
            );
          },
        ),
      ],
    );
  }
}