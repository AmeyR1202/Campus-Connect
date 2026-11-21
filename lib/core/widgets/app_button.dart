import 'package:campus_connect/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant {
  /// White background, black text (Used on dark screens, e.g. Onboarding 1, Account Ready)
  light,

  /// Black background, white text (Used on light screens, e.g. Onboarding 2, 3, Login, Sign Up)
  dark,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? trailing;
  final Widget? leading;
  final bool isLoading;
  final double height;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.light,
    this.trailing,
    this.leading,
    this.isLoading = false,
    this.height = 54,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = variant == AppButtonVariant.light;
    final backgroundColor = isLight ? AppColors.pureWhite : AppColors.pureBlack;
    final foregroundColor = isLight ? AppColors.pureBlack : AppColors.pureWhite;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.5),
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Row(
                mainAxisAlignment: (leading != null || trailing != null)
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (leading != null) leading!,
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: foregroundColor,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
      ),
    );
  }
}

