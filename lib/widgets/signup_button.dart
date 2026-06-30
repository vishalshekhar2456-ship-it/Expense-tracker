import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key, 
    required this.label,
    this.icon,
    this.filled = false,
    this.isGoogle = false,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool filled;
  final bool isGoogle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
   if (isGoogle) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: double.infinity,
      height: 56,
      child: SvgPicture.asset(
        'assets/icons/google_logo.svg',
        fit: BoxFit.contain,
      ),
    ),
  );
}
    final bg = filled ? AppColors.black : AppColors.white;
    final fg = filled ? AppColors.white : AppColors.black;
    final border = filled
        ? BorderSide.none
        : BorderSide(color: AppColors.border);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: border,
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon != null
                ? Icon(icon, size: 20, color: fg)
                : const SizedBox(width: 20),
            Text(label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: fg,
                )),
            Icon(Icons.arrow_forward, size: 20, color: fg),
          ],
        ),
      ),
    );
  }
}