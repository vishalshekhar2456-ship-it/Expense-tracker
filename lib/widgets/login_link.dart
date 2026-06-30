import 'package:flutter/material.dart';
import '../constants/colors.dart';

class LoginLink extends StatelessWidget {
  const LoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: AppColors.grey),
        children: [
          const TextSpan(text: 'Already have an account? '),
          TextSpan(
            text: 'Log In',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
            // recognizer: TapGestureRecognizer()..onTap = () {}
          ),
        ],
      ),
    );
  }
}