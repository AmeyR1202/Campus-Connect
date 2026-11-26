import 'package:flutter/material.dart';

/// Universal page transition animators for Campus Connect.
///
/// Replaces standard platform jumps/slides with modern, physics-inspired
/// transitions designed for dark/light contrast and smooth navigation.
class AppPageTransitions {
  const AppPageTransitions._();

  /// Shared-Axis Slide & Fade (Linear / Apple-style navigation).
  ///
  /// - Incoming screen glides in from a subtle 25% horizontal offset with an ease-out curve,
  ///   simultaneously fading from 0.0 -> 1.0.
  /// - Exiting screen retreats slightly by -8% with a gentle fade down to 0.85 opacity.
  /// - Eliminates harsh 100% full-screen block sliding when transitioning between
  ///   dark and light themes (e.g., Onboarding 1 to 2).
  static Widget sharedAxis(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // 1. Primary Transition: Incoming screen sliding in and fading
    final primaryOffset =
        Tween<Offset>(begin: const Offset(0.25, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    final primaryFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.85, curve: Curves.easeOut),
        reverseCurve: const Interval(0.15, 1.0, curve: Curves.easeIn),
      ),
    );

    // 2. Secondary Transition: Current screen retreating when another page is pushed on top
    final secondaryOffset =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.08, 0.0),
        ).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    final secondaryFade = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    return SlideTransition(
      position: secondaryOffset,
      child: FadeTransition(
        opacity: secondaryFade,
        child: SlideTransition(
          position: primaryOffset,
          child: FadeTransition(opacity: primaryFade, child: child),
        ),
      ),
    );
  }

  /// Subtle Fade-Through Transition (ideal for modal or auth state changes).
  static Widget fadeThrough(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fadeIn = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
    );
    final fadeOut = CurvedAnimation(
      parent: secondaryAnimation,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    );

    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 0.0).animate(fadeOut),
      child: FadeTransition(opacity: fadeIn, child: child),
    );
  }
}
