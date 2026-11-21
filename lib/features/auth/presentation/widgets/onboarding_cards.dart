import 'package:campus_connect/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Slide1CampusCard extends StatelessWidget {
  const Slide1CampusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 346 / 292, // Native Figma asset ratio
            child: Image.asset(
              'assets/images/campus_image.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'A PLACE TO BELONG',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              'C / C',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Slide 2 Card: "Your Monday" Schedule (Figma SVG)

class Slide2ScheduleCard extends StatelessWidget {
  const Slide2ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 346 / 304, // Native Figma asset ratio
            child: SvgPicture.asset(
              'assets/images/onboarding_timetable_composition.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ONE SCHEDULE FOR EVERYTHING',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              'LIVE SYNC',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Slide 3 Card: Student Communities

class Slide3CommunityCard extends StatelessWidget {
  const Slide3CommunityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 346 / 292,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Upper photo: Student group photography from Figma
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/students_image.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Lower banner: Attached event pill (#151515) matching Figma SVG
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: const Color(0xFF151515),
                    child: Row(
                      children: [
                        // Calendar Icon
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Color(0xFFF9F9F6),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Event title & schedule
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'CATCH ME ON THE GRASS',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                  color: Color(0xFFF9F9F6),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'FRI • 23 OCT • 5:00 PM',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                  color: Color(0xFFB8B8B3),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Action arrow
                        const Icon(
                          Icons.arrow_outward_rounded,
                          size: 16,
                          color: Color(0xFFF9F9F6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'A SPACE FOR EVERYONE',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              '120+ COMMUNITIES',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
