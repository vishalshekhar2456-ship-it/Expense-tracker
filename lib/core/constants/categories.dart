/// A suggested category the user can add with one tap. Stored using the same
/// string keys the database persists (`icon` / `color`), which
/// [categoryIcon]/[categoryColor] in `category_visuals.dart` resolve to
/// concrete [IconData]/[Color]. Picking from this list avoids typos.
class CategoryPreset {
  final String name;

  /// Icon key — must be one of [kCategoryIconKeys].
  final String icon;

  /// Color key — must be one of [kCategoryColorKeys].
  final String color;

  const CategoryPreset({
    required this.name,
    required this.icon,
    required this.color,
  });
}

/// Curated catalog of common expense categories. The first six mirror the
/// defaults seeded on first launch (they'll be filtered out of the "add"
/// picker once present); the rest are extra suggestions.
const List<CategoryPreset> kCategoryPresets = [
  CategoryPreset(name: 'Food', icon: 'restaurant', color: 'coral'),
  CategoryPreset(name: 'Shopping', icon: 'shopping_bag', color: 'marigold'),
  CategoryPreset(name: 'Transport', icon: 'directions_car', color: 'teal'),
  CategoryPreset(name: 'Utilities', icon: 'bolt', color: 'grape'),
  CategoryPreset(name: 'Fun', icon: 'movie', color: 'sky'),
  CategoryPreset(name: 'Health', icon: 'favorite', color: 'pink'),
  CategoryPreset(name: 'Groceries', icon: 'shopping_cart', color: 'teal'),
  CategoryPreset(name: 'Coffee', icon: 'local_cafe', color: 'marigold'),
  CategoryPreset(name: 'Rent', icon: 'home', color: 'grape'),
  CategoryPreset(name: 'Travel', icon: 'flight', color: 'sky'),
  CategoryPreset(name: 'Subscriptions', icon: 'subscriptions', color: 'pink'),
  CategoryPreset(name: 'Education', icon: 'school', color: 'teal'),
  CategoryPreset(name: 'Gifts', icon: 'card_giftcard', color: 'coral'),
  CategoryPreset(name: 'Pets', icon: 'pets', color: 'marigold'),
  CategoryPreset(name: 'Fitness', icon: 'fitness_center', color: 'teal'),
];

/// Color keys available when creating a custom category. Must match the cases
/// handled by `categoryColor` in `category_visuals.dart`.
const List<String> kCategoryColorKeys = [
  'coral',
  'marigold',
  'teal',
  'grape',
  'sky',
  'pink',
];

/// Icon keys available when creating a custom category. Must match the cases
/// handled by `categoryIcon` in `category_visuals.dart`.
const List<String> kCategoryIconKeys = [
  'restaurant',
  'shopping_bag',
  'shopping_cart',
  'directions_car',
  'bolt',
  'movie',
  'favorite',
  'local_cafe',
  'home',
  'flight',
  'subscriptions',
  'school',
  'card_giftcard',
  'pets',
  'fitness_center',
  'category',
];
