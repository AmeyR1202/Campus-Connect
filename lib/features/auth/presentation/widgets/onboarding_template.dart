import 'package:auto_route/auto_route.dart';
import 'package:campus_connect/core/routes/app_router.gr.dart';
import 'package:campus_connect/core/theme/app_colors.dart';
import 'package:campus_connect/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingTemplate extends StatelessWidget {
  final Widget card;
  final String title;
  final String subtitle;
  final int currentStep; // 0, 1, or 2
  final String buttonText;
  final Widget? buttonTrailing;
  final VoidCallback onButtonPressed;
  final bool isDark;
  final VoidCallback? onSkipPressed;
  final VoidCallback? onLoginPressed;

  const OnboardingTemplate({
    super.key,
    required this.card,
    required this.title,
    required this.subtitle,
    required this.currentStep,
    required this.buttonText,
    this.buttonTrailing = const Icon(Icons.arrow_forward, size: 18),
    required this.onButtonPressed,
    this.isDark = false,
    this.onSkipPressed,
    this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark ? AppColors.pureBlack : AppColors.pureWhite;
    final textColor = isDark ? AppColors.warmIvory : AppColors.pureBlack;
    final secondaryTextColor = isDark
        ? AppColors.textSecondary
        : AppColors.textMuted;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Bar: "Campus Connect" + "Skip"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Campus Connect",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: textColor,
                      ),
                    ),
                    TextButton(
                      onPressed:
                          onSkipPressed ??
                          () => context.router.push(const LoginRoute()),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. Hero Card
                card,

                // Spacer 1: Balanced breathing room above typography
                const Spacer(flex: 1),

                // 3. Headline & Subtitle
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'InstrumentSerif',
                    fontSize: 56,
                    height: 1.0,
                    letterSpacing: -0.5,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 14),

                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.45,
                    color: secondaryTextColor,
                  ),
                ),

                // Spacer 2: Balanced breathing room above actions
                const Spacer(flex: 1),

                // 4. Dash Indicators
                Row(
                  children: [
                    _buildDash(stepIndex: 0),
                    const SizedBox(width: 6),
                    _buildDash(stepIndex: 1),
                    const SizedBox(width: 6),
                    _buildDash(stepIndex: 2),
                    const Spacer(),
                    Text(
                      '0${currentStep + 1} / 03',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 5. CTA Button
                AppButton(
                  text: buttonText,
                  variant: isDark
                      ? AppButtonVariant.light
                      : AppButtonVariant.dark,
                  trailing: buttonTrailing,
                  onPressed: onButtonPressed,
                ),
                const SizedBox(height: 24),

                // 6. Login Link Footer
                Center(
                  child: GestureDetector(
                    onTap:
                        onLoginPressed ??
                        () => context.router.push(const LoginRoute()),
                    child: RichText(
                      text: TextSpan(
                        text: "Already a part of it? ",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(
                            text: "Log in",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDash({required int stepIndex}) {
    final isActive = currentStep == stepIndex;
    final activeColor = isDark ? AppColors.pureWhite : AppColors.pureBlack;
    final inactiveColor = isDark
        ? AppColors.borderGrey
        : const Color(0xFFE5E5EA);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: isActive ? 24 : 12,
      height: 3,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
