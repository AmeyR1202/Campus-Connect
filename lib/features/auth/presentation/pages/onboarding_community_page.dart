import 'package:auto_route/auto_route.dart';
import 'package:campus_connect/core/routes/app_router.gr.dart';
import 'package:campus_connect/features/auth/presentation/widgets/onboarding_cards.dart';
import 'package:campus_connect/features/auth/presentation/widgets/onboarding_template.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OnboardingCommunityPage extends StatelessWidget {
  const OnboardingCommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      card: const Slide3CommunityCard(),
      title: 'Find your people.\nFind your thing.',
      subtitle:
          'Discover events, meet your peers, and form smaller groups that make campus feel personal.',
      currentStep: 2,
      buttonText: 'Create an account',
      buttonTrailing: null,
      isDark: false,
      onButtonPressed: () {
        context.router.push(const SignUpRoute());
      },
    );
  }
}
