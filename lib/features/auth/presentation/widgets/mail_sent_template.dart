import 'package:campus_connect/core/theme/app_colors.dart';
import 'package:campus_connect/core/utils/app_launcher.dart';
import 'package:campus_connect/core/widgets/app_back_button.dart';
import 'package:campus_connect/core/widgets/app_button.dart';
import 'package:campus_connect/features/auth/presentation/widgets/orbiting_mail_graphic.dart';
import 'package:flutter/material.dart';

/// Shared DRY template for "Check your inbox / Mail on its way" screens
/// (used by both [VerifyEmailPage] and [ForgotPasswordPage]).
class MailSentTemplate extends StatelessWidget {
  final String graphicCaption;
  final String eyebrow;
  final String title;
  final String subtitle;
  final String email;
  final String leftActionLabel;
  final VoidCallback onLeftActionTap;
  final String rightActionLabel;
  final VoidCallback onRightActionTap;
  final VoidCallback? onBackPressed;

  const MailSentTemplate({
    super.key,
    required this.graphicCaption,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.email,
    required this.leftActionLabel,
    required this.onLeftActionTap,
    required this.rightActionLabel,
    required this.onRightActionTap,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Top Navigation Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppBackButton(onPressed: onBackPressed),
                        const Text(
                          'Campus\nConnect',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            height: 1.05,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: Color(0xFF151515),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 2. Orbiting Mail Graphic + Caption
                    const Center(child: OrbitingMailGraphic()),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        graphicCaption,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.4,
                          color: Color(0xFF666663),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 3. Hero Headline Block
                    Text(
                      eyebrow,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.4,
                        color: Color(0xFF666663),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'InstrumentSerif',
                        fontSize: 48,
                        height: 1.0,
                        letterSpacing: -0.5,
                        color: Color(0xFF151515),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: Color(0xFF666663),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 4. Highlighted "SENT TO" Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          const Text(
                            'SENT TO',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.4,
                              color: Color(0xFF666663),
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              color: Color(0xFF151515),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 5. Spam Folder Info Note
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: Color(0xFF666663),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Can't find it? Check your spam folder, or resend the email below.",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              height: 1.45,
                              color: Color(0xFF666663),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),
                    const SizedBox(height: 24),

                    // 6. Primary Action: Open mail app
                    AppButton(
                      text: 'Open mail app',
                      variant: AppButtonVariant.dark,
                      trailing: const Icon(Icons.north_east, size: 18),
                      onPressed: () async {
                        final launched = await AppLauncher.openMailApp();
                        if (!launched && context.mounted) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No mail app found on this device.',
                                ),
                              ),
                            );
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // 7. Footer Action Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: onLeftActionTap,
                          child: Text(
                            leftActionLabel,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF151515),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF151515),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onRightActionTap,
                          child: Text(
                            rightActionLabel,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF666663),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF666663),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

