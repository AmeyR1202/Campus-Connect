import 'package:auto_route/auto_route.dart';
import 'package:campus_connect/core/routes/app_router.gr.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  /// TODO: study more about ticker provider mixin and Vsync
  late final AnimationController _controller;
  late final Animation<double> _revealAnimation;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _revealAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));
    // Start text reveal animation
    _controller.forward().then((_) {
      if (mounted) {
        setState(() => _animationCompleted = true);
        _evaluateNavigation(context.read<AuthBloc>().state);
      }
    });
  }

  void _evaluateNavigation(AuthState state) {
    // Guard 1: Never navigate until the animation completes
    if (!_animationCompleted) return;
    // Guard 2: React to the authoritative AuthBloc state
    state.whenOrNull(
      unauthenticated: () => context.router.replace(const OnboardingRoute()),
      unverified: (user) => context.router.replace(const VerifyEmailRoute()),
      authenticated: (user) {
        // If user is already authenticated, can route to onboarding/home
        context.router.replace(
          const OnboardingRoute(),
        ); // TODO: Fix this onboardinbg page navigation
      },
      failure: (_) => context.router.replace(const OnboardingRoute()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        _evaluateNavigation(state);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'Campus Connect',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
              ),
              AnimatedBuilder(
                animation: _revealAnimation,
                builder: (context, child) {
                  return Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: _revealAnimation.value,
                        child: Container(color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
