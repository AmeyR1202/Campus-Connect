import 'package:auto_route/auto_route.dart';
import 'package:campus_connect/core/routes/app_router.gr.dart';
import 'package:campus_connect/core/theme/app_colors.dart';
import 'package:campus_connect/core/widgets/app_button.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_event.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthBloc, ({String name, String email})>(
      (bloc) => bloc.state.maybeWhen(
        authenticated: (u) => (name: u.username, email: u.email),
        orElse: () => (name: '', email: ''),
      ),
    );

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          ModalRoute.of(context)?.isCurrent ?? false,
      listener: (context, state) {
        state.whenOrNull(
          unauthenticated: () {
            context.router.replaceAll([const LoginRoute()]);
          },
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.pureWhite,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Campus Connect',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: Color(0xFF151515),
                  ),
                ),
                const Spacer(),
                const Text(
                  'SIGNED IN',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                    color: Color(0xFF666663),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  user.name.isNotEmpty
                      ? 'Welcome,\n${user.name}.'
                      : 'Welcome to\nCampus.',
                  style: const TextStyle(
                    fontFamily: 'InstrumentSerif',
                    fontSize: 48,
                    height: 1.0,
                    letterSpacing: -0.5,
                    color: Color(0xFF151515),
                  ),
                ),
                if (user.email.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Color(0xFF666663),
                    ),
                  ),
                ],
                const Spacer(),
                AppButton(
                  text: 'Log out',
                  variant: AppButtonVariant.dark,
                  onPressed: () {
                    context.read<AuthBloc>().add(const LogoutSubmitted());
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

