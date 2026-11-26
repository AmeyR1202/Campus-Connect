import 'package:campus_connect/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SocialSignInButton extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onPressed;

  const SocialSignInButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.pureWhite,
        foregroundColor: AppColors.pureBlack,
        side: const BorderSide(color: Color(0xFFE5E5E0)),
        minimumSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),

      child: Row(
        children: [
          // 1. Leading icon at start
          icon,

          // 2. Centered label across available space
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.pureBlack,
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
