import 'package:auto_route/auto_route.dart';
import 'package:campus_connect/core/routes/app_router.gr.dart';
import 'package:campus_connect/core/theme/app_colors.dart';
import 'package:campus_connect/core/widgets/app_button.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_state.dart';
import 'package:campus_connect/features/auth/presentation/widgets/orbiting_mail_graphic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AccountReadyPage extends StatelessWidget {
  const AccountReadyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final username = context.select<AuthBloc, String>(
      (bloc) => bloc.state.whenOrNull(authenticated: (u) => u.username) ?? '',
    );

    final greeting = username.isNotEmpty
        ? "You're all set, $username. Your schedule, communities, and campus life are ready."
        : "You're all set. Your schedule, communities, and campus life are ready.";

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.pureBlack,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Top Brand Header
                      const Text(
                        'Campus Connect',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          color: AppColors.warmIvory,
                        ),
                      ),
                      const Spacer(),

                      // 2. Dark Orbiting Checkmark Graphic
                      const Center(
                        child: OrbitingMailGraphic(
                          icon: Icons.check_rounded,
                          isDark: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'ALL SET',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.4,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const Spacer(),

                      // 3. Hero Headline Block
                      const Text(
                        'ACCOUNT VERIFIED',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.4,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Welcome to\ncampus.',
                        style: TextStyle(
                          fontFamily: 'InstrumentSerif',
                          fontSize: 52,
                          height: 1.0,
                          letterSpacing: -0.5,
                          color: AppColors.warmIvory,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        greeting,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.45,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 4. Primary Light CTA Button
                      AppButton(
                        text: 'Enter Campus Connect',
                        variant: AppButtonVariant.light,
                        trailing: const Icon(Icons.arrow_forward, size: 18),
                        onPressed: () {
                          context.router.replaceAll([const HomeRoute()]);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
