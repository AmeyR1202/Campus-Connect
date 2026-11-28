import 'package:campus_connect/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrbitingMailGraphic extends StatefulWidget {
  final IconData icon;
  final bool isDark;

  const OrbitingMailGraphic({
    super.key,
    this.icon = Icons.mail_outline_rounded,
    this.isDark = false,
  });

  @override
  State<OrbitingMailGraphic> createState() => OrbitingMailGraphicState();
}

class OrbitingMailGraphicState extends State<OrbitingMailGraphic>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(); // Loops endlessly 0.0 -> 1.0 (1 full turn every 6s)
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ringColor = widget.isDark
        ? AppColors.borderGrey
        : const Color(0xFFE5E5E0);
    final dotColor = widget.isDark
        ? AppColors.warmIvory
        : const Color(0xFF151515);
    final badgeBg = widget.isDark
        ? AppColors.warmIvory
        : const Color(0xFF151515);
    final iconColor = widget.isDark
        ? const Color(0xFF151515)
        : Colors.white;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // 1. Rotating Outer Ring + Orbiting Dot
        RotationTransition(
          turns: _controller,
          child: SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Outer hairline ring
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ringColor,
                      width: 1,
                    ),
                  ),
                ),
                // Dot centered on the top stroke of the ring
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: const Offset(0, -3.5),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. Static Middle Ring
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ringColor, width: 1),
          ),
        ),

        // 3. Static Center Circle + Icon
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: badgeBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon,
            color: iconColor,
            size: 26,
          ),
        ),
      ],
    );
  }
}
