import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expenseful/app/theme.dart';
import 'package:expenseful/core/constants/categories.dart';
import 'package:expenseful/core/constants/category_visuals.dart';
import 'package:expenseful/core/text_similarity.dart';
import 'package:expenseful/data/database.dart';
import 'package:expenseful/providers/categories_provider.dart';
import 'package:expenseful/providers/database_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(allCategoriesProvider).value ?? const <Category>[];
    final active = all.where((c) => !c.isArchived).toList();
    final archived = all.where((c) => c.isArchived).toList();

    return Scaffold(
      backgroundColor: AppColors.paperBackground,
      appBar: AppBar(
        backgroundColor: AppColors.paperBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.plumInk),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Categories', style: AppTypography.displayMedium),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.grape,
        foregroundColor: Colors.white,
        onPressed: () => AddCategorySheet.show(context, all),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const _SectionHeader('YOUR CATEGORIES'),
          if (active.isEmpty)
            _emptyHint('No categories yet. Tap Add to create one.')
          else
            for (final c in active) _CategoryRow(category: c, isArchived: false),
          if (archived.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const _SectionHeader('HIDDEN'),
            for (final c in archived) _CategoryRow(category: c, isArchived: true),
          ],
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _emptyHint(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Center(
          child: Text(text,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.plumInk.withValues(alpha: 0.45),
              )),
        ),
      );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
      child: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          fontSize: 12,
          letterSpacing: 0.6,
          color: AppColors.plumInk.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _CategoryRow extends ConsumerWidget {
  final Category category;
  final bool isArchived;

  const _CategoryRow({required this.category, required this.isArchived});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = categoryColor(category.color);
    final icon = categoryIcon(category.icon);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: AppSpacing.xs),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: isArchived ? 0.06 : 0.12),
            child: Icon(icon,
                color: isArchived ? color.withValues(alpha: 0.5) : color,
                size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              category.name,
              style: AppTypography.bodyRegular.copyWith(
                fontSize: 15,
                color: isArchived
                    ? AppColors.plumInk.withValues(alpha: 0.5)
                    : AppColors.plumInk,
              ),
            ),
          ),
          if (isArchived)
            TextButton(
              onPressed: () =>
                  ref.read(appDatabaseProvider).restoreCategory(category.id),
              child: const Text('Restore'),
            )
          else
            IconButton(
              tooltip: 'Remove',
              icon: Icon(Icons.remove_circle_outline_rounded,
                  color: AppColors.plumInk.withValues(alpha: 0.4)),
              onPressed: () async {
                final db = ref.read(appDatabaseProvider);
                await db.archiveCategory(category.id);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('${category.name} hidden'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () => db.restoreCategory(category.id),
                      ),
                    ),
                  );
              },
            ),
        ],
      ),
    );
  }
}

/// Bottom sheet to add a category — from presets (one tap, no typos) or as a
/// custom entry with typo protection.
class AddCategorySheet extends ConsumerStatefulWidget {
  final List<Category> existing;
  const AddCategorySheet({super.key, required this.existing});

  static Future<void> show(BuildContext context, List<Category> existing) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
      ),
      builder: (_) => AddCategorySheet(existing: existing),
    );
  }

  @override
  ConsumerState<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends ConsumerState<AddCategorySheet> {
  final _nameController = TextEditingController();
  String _selectedIcon = 'category';
  String _selectedColor = 'grape';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ----- lookup helpers over the current categories -----

  Category? _byName(String name) {
    final needle = name.toLowerCase();
    for (final c in widget.existing) {
      if (c.name.toLowerCase() == needle) return c;
    }
    return null;
  }

  bool _isActiveName(String name) {
    final c = _byName(name);
    return c != null && !c.isArchived;
  }

  Iterable<String> get _presetNames => kCategoryPresets.map((p) => p.name);

  List<CategoryPreset> get _availablePresets =>
      kCategoryPresets.where((p) => !_isActiveName(p.name)).toList();

  // ----- actions -----

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Adds a category by name; restores instead if a hidden one already matches.
  /// Returns true if something was added/restored.
  Future<bool> _addOrRestore(String name, String icon, String color) async {
    final normalized = normalizeCategoryName(name);
    final db = ref.read(appDatabaseProvider);
    final existing = _byName(normalized);

    if (existing != null) {
      if (existing.isArchived) {
        await db.restoreCategory(existing.id);
        _toast('Restored ${existing.name}');
        return true;
      }
      _toast('${existing.name} already exists');
      return false;
    }

    await db.addCategory(name: normalized, icon: icon, color: color);
    return true;
  }

  Future<void> _addPreset(CategoryPreset preset) async {
    final added = await _addOrRestore(preset.name, preset.icon, preset.color);
    if (added && mounted) Navigator.of(context).pop();
  }

  Future<void> _submitCustom() async {
    final normalized = normalizeCategoryName(_nameController.text);
    if (normalized.isEmpty) {
      _toast('Enter a category name');
      return;
    }

    // Exact match (active -> block, archived -> restore).
    final existing = _byName(normalized);
    if (existing != null) {
      if (existing.isArchived) {
        await ref.read(appDatabaseProvider).restoreCategory(existing.id);
        if (mounted) Navigator.of(context).pop();
        _toast('Restored ${existing.name}');
      } else {
        _toast('${existing.name} already exists');
      }
      return;
    }

    // Near-miss typo? Suggest the closest existing/preset name.
    final candidates = <String>{
      ...widget.existing.map((c) => c.name),
      ..._presetNames,
    };
    final suggestion = closestMatch(normalized, candidates);
    if (suggestion != null) {
      final useSuggestion = await _confirmSuggestion(normalized, suggestion);
      if (useSuggestion == null) return; // cancelled
      if (useSuggestion) {
        await _resolveSuggestion(suggestion);
        return;
      }
      // else: fall through and add the typed name anyway
    }

    await _addOrRestore(normalized, _selectedIcon, _selectedColor);
    if (mounted) Navigator.of(context).pop();
  }

  /// null = cancel, true = use suggestion, false = add anyway.
  Future<bool?> _confirmSuggestion(String typed, String suggestion) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Did you mean "$suggestion"?',
            style: AppTypography.displayMedium.copyWith(fontSize: 18)),
        content: Text(
          '"$typed" looks close to "$suggestion". '
          'Use the existing one to avoid duplicates?',
          style: AppTypography.bodyRegular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Add anyway'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Use "$suggestion"'),
          ),
        ],
      ),
    );
  }

  Future<void> _resolveSuggestion(String suggestion) async {
    final existing = _byName(suggestion);
    if (existing != null) {
      if (existing.isArchived) {
        await ref.read(appDatabaseProvider).restoreCategory(existing.id);
        if (mounted) Navigator.of(context).pop();
        _toast('Restored ${existing.name}');
      } else {
        if (mounted) Navigator.of(context).pop();
        _toast('${existing.name} already exists');
      }
      return;
    }
    // Otherwise it's a preset name.
    final preset = kCategoryPresets.firstWhere((p) => p.name == suggestion);
    await _addPreset(preset);
  }

  @override
  Widget build(BuildContext context) {
    final presets = _availablePresets;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add category', style: AppTypography.displayMedium),
              const SizedBox(height: AppSpacing.md),
              if (presets.isNotEmpty) ...[
                Text('SUGGESTIONS',
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 12,
                      letterSpacing: 0.6,
                      color: AppColors.plumInk.withValues(alpha: 0.5),
                    )),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final p in presets)
                      ActionChip(
                        avatar: Icon(categoryIcon(p.icon),
                            size: 18, color: categoryColor(p.color)),
                        label: Text(p.name),
                        backgroundColor: AppColors.surfaceMuted,
                        onPressed: () => _addPreset(p),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              Text('OR CREATE YOUR OWN',
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 12,
                    letterSpacing: 0.6,
                    color: AppColors.plumInk.withValues(alpha: 0.5),
                  )),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _nameController,
                stylusHandwritingEnabled: false,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [LengthLimitingTextInputFormatter(24)],
                decoration: const InputDecoration(
                  hintText: 'Category name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _submitCustom(),
              ),
              const SizedBox(height: AppSpacing.md),
              _IconPicker(
                selected: _selectedIcon,
                onSelect: (k) => setState(() => _selectedIcon = k),
                color: categoryColor(_selectedColor),
              ),
              const SizedBox(height: AppSpacing.md),
              _ColorPicker(
                selected: _selectedColor,
                onSelect: (k) => setState(() => _selectedColor = k),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.grape,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                    ),
                  ),
                  onPressed: _submitCustom,
                  child: const Text('Add category'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  final Color color;

  const _IconPicker({
    required this.selected,
    required this.onSelect,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final key in kCategoryIconKeys)
          GestureDetector(
            onTap: () => onSelect(key),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected == key
                    ? color.withValues(alpha: 0.18)
                    : AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadii.card / 2),
                border: selected == key
                    ? Border.all(color: color, width: 2)
                    : null,
              ),
              child: Icon(categoryIcon(key),
                  size: 20,
                  color: selected == key
                      ? color
                      : AppColors.plumInk.withValues(alpha: 0.7)),
            ),
          ),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const _ColorPicker({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      children: [
        for (final key in kCategoryColorKeys)
          GestureDetector(
            onTap: () => onSelect(key),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: categoryColor(key),
                shape: BoxShape.circle,
                border: selected == key
                    ? Border.all(color: AppColors.plumInk, width: 2.5)
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}
