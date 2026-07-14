import 'package:flutter/material.dart';
import 'package:expenseful/app/theme.dart';

Color categoryColor(String? color) {
  switch (color) {
    case 'coral':
      return AppColors.coral;
    case 'marigold':
      return AppColors.marigold;
    case 'teal':
      return AppColors.teal;
    case 'grape':
      return AppColors.grape;
    case 'sky':
      return AppColors.sky;
    case 'pink':
      return AppColors.pink;
    default:
      return AppColors.grape;
  }
}

IconData categoryIcon(String? icon) {
  switch (icon) {
    case 'restaurant':
      return Icons.restaurant_rounded;
    case 'shopping_bag':
      return Icons.shopping_bag_rounded;
    case 'directions_car':
      return Icons.directions_car_rounded;
    case 'bolt':
      return Icons.bolt_rounded;
    case 'movie':
      return Icons.movie_rounded;
    case 'favorite':
      return Icons.favorite_rounded;
    default:
      return Icons.category_rounded;
  }
}