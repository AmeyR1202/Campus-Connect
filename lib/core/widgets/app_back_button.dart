// lib/core/widgets/app_back_button.dart

import 'package:auto_route/auto_route.dart';
import 'package:campus_connect/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color color;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.color = AppColors.pureBlack,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => context.router.maybePop(),
      icon: SvgPicture.asset(
        'assets/svgs/back_button.svg',
        width: 25,
        height: 25,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      alignment: Alignment.centerLeft,
      splashRadius: 20,
    );
  }
}
