import 'package:auto_route/auto_route.dart';
import 'package:campus_connect/core/routes/app_router.gr.dart';
import 'package:campus_connect/features/auth/presentation/widgets/onboarding_cards.dart';
import 'package:campus_connect/features/auth/presentation/widgets/onboarding_template.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OnboardingSchedulePage extends StatelessWidget {
  const OnboardingSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      card: const Slide2ScheduleCard(),
      title: 'Less chaos.\nMore campus.',
      subtitle:
          'Keep your timetable, events, and tasks in one together. Make room for life beyond the lecture.',
      currentStep: 1,
      buttonText: 'Next',
      isDark: false,
      onButtonPressed: () {
        context.router.push(const OnboardingCommunityRoute());
      },
    );
  }
}
