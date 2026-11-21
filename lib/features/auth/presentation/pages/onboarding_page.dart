import 'package:auto_route/auto_route.dart';
import 'package:campus_connect/core/routes/app_router.gr.dart';
import 'package:campus_connect/features/auth/presentation/widgets/onboarding_cards.dart';
import 'package:campus_connect/features/auth/presentation/widgets/onboarding_template.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      card: const Slide1CampusCard(),
      title: 'Your campus.\nYour people.',
      subtitle:
          'Welcome to Campus Connect. A little closer to everything that makes campus yours.',
      currentStep: 0,
      buttonText: 'Find your campus',
      isDark: true,
      onButtonPressed: () {
        context.router.push(const OnboardingScheduleRoute());
      },
    );
  }
}
