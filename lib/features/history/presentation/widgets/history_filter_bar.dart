import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expenseful/app/theme.dart';
import 'package:expenseful/core/constants/category_visuals.dart';
import 'package:expenseful/core/widgets/app_text_field.dart';
import 'package:expenseful/data/database.dart';
import 'package:expenseful/features/history/domain/history_filter.dart';

/// Search field + date-range chip + category chips that drive the history
/// screen's [HistoryFilter]. Purely presentational: it reports changes up via
/// [onChanged] and owns no filter state itself.
class HistoryFilterBar extends StatelessWidget {
  final HistoryFilter filter;
  final List<Category> categories;
  final TextEditingController searchController;
  final ValueChanged<HistoryFilter> onChanged;

  const HistoryFilterBar({
    super.key,
    required this.filter,
    required this.categories,
    required this.searchController,
    required this.onChanged,
  });

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: filter.dateRange,
    );
    if (picked != null) {
      onChanged(filter.copyWith(dateRange: picked));
    }
  }

  void _toggleCategory(String id) {
    final next = Set<String>.from(filter.categoryIds);
    if (!next.remove(id)) next.add(id);
    onChanged(filter.copyWith(categoryIds: next));
  }

  String _formatRange(DateTimeRange range) {
    final fmt = DateFormat('d MMM');
    return '${fmt.format(range.start)} – ${fmt.format(range.end)}';
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = filter.query.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: searchController,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) => onChanged(filter.copyWith(query: value)),
          decoration: InputDecoration(
            hintText: 'Search merchant or notes',
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            suffixIcon: hasQuery
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () {
                      searchController.clear();
                      onChanged(filter.copyWith(query: ''));
                    },
                  )
                : null,
            isDense: true,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.chip),
              borderSide: BorderSide(
                color: AppColors.plumInk.withValues(alpha: 0.12),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.chip),
              borderSide: BorderSide(
                color: AppColors.plumInk.withValues(alpha: 0.12),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                avatar: Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: filter.dateRange != null
                      ? AppColors.grape
                      : AppColors.plumInk.withValues(alpha: 0.6),
                ),
                label: Text(
                  filter.dateRange != null
                      ? _formatRange(filter.dateRange!)
                      : 'Date range',
                ),
                selected: filter.dateRange != null,
                showCheckmark: false,
                onSelected: (_) => _pickDateRange(context),
                onDeleted: filter.dateRange != null
                    ? () => onChanged(filter.copyWith(clearDateRange: true))
                    : null,
                deleteIcon: const Icon(Icons.close_rounded, size: 16),
              ),
              for (final category in categories) ...[
                const SizedBox(width: AppSpacing.sm),
                _CategoryChip(
                  category: category,
                  selected: filter.categoryIds.contains(category.id),
                  onSelected: () => _toggleCategory(category.id),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final Category category;
  final bool selected;
  final VoidCallback onSelected;

  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(category.color);
    return FilterChip(
      avatar: Icon(categoryIcon(category.icon), size: 16, color: color),
      label: Text(category.name),
      selected: selected,
      showCheckmark: false,
      selectedColor: color.withValues(alpha: 0.16),
      side: selected
          ? BorderSide(color: color.withValues(alpha: 0.5))
          : BorderSide(color: AppColors.plumInk.withValues(alpha: 0.12)),
      onSelected: (_) => onSelected(),
    );
  }
}
