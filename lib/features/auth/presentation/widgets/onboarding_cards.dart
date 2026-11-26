import 'package:campus_connect/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

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

// Slide 2 Card: "Your Monday" Schedule

class Slide2ScheduleCard extends StatelessWidget {
  const Slide2ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 346 / 292,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E5E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Header: "Your Monday" + Day selector pills
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Monday',
                        style: TextStyle(
                          fontFamily: 'InstrumentSerif',
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                          color: AppColors.pureBlack,
                        ),
                      ),
                      Row(
                        children: [
                          _buildDayPill('M', isActive: true),
                          const SizedBox(width: 4),
                          _buildDayPill('T'),
                          const SizedBox(width: 4),
                          _buildDayPill('W'),
                          const SizedBox(width: 4),
                          _buildDayPill('T'),
                          const SizedBox(width: 4),
                          _buildDayPill('F'),
                        ],
                      ),
                    ],
                  ),

                  // Schedule item 1: Design Thinking
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Design Thinking',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.pureBlack,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Hall B402 • Main Building',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0EE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '10:00 - 11:30',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.pureBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Schedule item 2: Attendance / Status notice
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: Color(0xFF10B981),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Attendance is high • 10/12 sessions',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.pureBlack,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: AppColors.textMuted,
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

  static Widget _buildDayPill(String day, {bool isActive = false}) {
    return Container(
      width: 22,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? AppColors.pureBlack : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: isActive ? null : Border.all(color: const Color(0xFFD1D1D6)),
      ),
      child: Text(
        day,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isActive ? AppColors.pureWhite : const Color(0xFF8E8E93),
        ),
      ),
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
