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
    case 'shopping_cart':
      return Icons.shopping_cart_rounded;
    case 'directions_car':
      return Icons.directions_car_rounded;
    case 'bolt':
      return Icons.bolt_rounded;
    case 'movie':
      return Icons.movie_rounded;
    case 'favorite':
      return Icons.favorite_rounded;
    case 'local_cafe':
      return Icons.local_cafe_rounded;
    case 'home':
      return Icons.home_rounded;
    case 'flight':
      return Icons.flight_rounded;
    case 'subscriptions':
      return Icons.subscriptions_rounded;
    case 'school':
      return Icons.school_rounded;
    case 'card_giftcard':
      return Icons.card_giftcard_rounded;
    case 'pets':
      return Icons.pets_rounded;
    case 'fitness_center':
      return Icons.fitness_center_rounded;
    default:
      return Icons.category_rounded;
  }
}