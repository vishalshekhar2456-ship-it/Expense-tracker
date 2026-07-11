import 'package:expenseful/app/theme.dart';
import 'package:flutter/material.dart';

  class CategoryOption {
  final String label;
  final IconData icon;
  final Color color;
  const CategoryOption(this.label, this.icon, this.color);
}

   const List<CategoryOption> categories = [
    CategoryOption('Food', Icons.restaurant_rounded, AppColors.coral),
    CategoryOption('Shopping', Icons.shopping_bag_rounded, AppColors.marigold),
    CategoryOption('Transport', Icons.directions_car_rounded, AppColors.teal),
    CategoryOption('Utilities', Icons.bolt_rounded, AppColors.grape),
    CategoryOption('Fun', Icons.movie_rounded, AppColors.sky),
    CategoryOption('Health', Icons.favorite_rounded, AppColors.pink),
  ];