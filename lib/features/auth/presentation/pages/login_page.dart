import 'package:auto_route/auto_route.dart';
import 'package:campus_connect/core/routes/app_router.gr.dart';
import 'package:campus_connect/core/theme/app_colors.dart';
import 'package:campus_connect/core/widgets/app_back_button.dart';
import 'package:campus_connect/core/widgets/app_button.dart';
import 'package:campus_connect/core/widgets/app_text_field.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_event.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_state.dart';
import 'package:campus_connect/features/auth/presentation/cubit/login_form_cubit.dart';
import 'package:campus_connect/features/auth/presentation/cubit/login_form_state.dart';
import 'package:campus_connect/features/auth/presentation/widgets/social_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginFormCubit(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode()
      ..addListener(() {
        if (!_emailFocusNode.hasFocus) {
          context.read<LoginFormCubit>().emailUnfocused();
        }
      });
    _passwordFocusNode = FocusNode()
      ..addListener(() {
        if (!_passwordFocusNode.hasFocus) {
          context.read<LoginFormCubit>().passwordUnfocused();
        }
      });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final cubit = context.read<LoginFormCubit>();
    if (cubit.validate()) {
      context.read<AuthBloc>().add(
        LoginSubmitted(
          email: cubit.state.email.value.trim(),
          password: cubit.state.password.value,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          ModalRoute.of(context)?.isCurrent ?? false,
      listener: (context, state) {
        state.whenOrNull(
          failure: (failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(failure.message)));
          },

          unverified: (_) =>
              context.router.replaceAll([const VerifyEmailRoute()]),
          authenticated: (_) {
            context.router.replaceAll([const HomeRoute()]);
          },
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              // Ensures you never get a bottom RenderFlex overflow when keyboard appears.
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Top Navigation Bar: Back Button + Plain Text Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        AppBackButton(),
                        Text(
                          'Campus\nConnect',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            height: 1.05,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: Color(0xFF151515),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // 2. Hero Headline Block
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'BACK TO YOUR COMMUNITY',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.4,
                            color: Color(0xFF666663),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Good to have\nyou back.',
                          style: TextStyle(
                            fontFamily: 'InstrumentSerif',
                            fontSize: 48,
                            height: 1.0,
                            letterSpacing: -0.5,
                            color: Color(0xFF151515),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Log in to pick up where campus left off.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: Color(0xFF666663),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // 3. Social Sign-In Buttons
                    SocialSignInButton(
                      title: 'Sign in with Google',
                      icon: SvgPicture.asset(
                        'assets/svgs/google.svg',
                        width: 20,
                        height: 20,
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                GoogleSignInSubmitted(),
                              );
                            },
                    ),
                    const SizedBox(height: 12),
                    SocialSignInButton(
                      title: 'Sign in with Apple',
                      icon: SvgPicture.asset(
                        'assets/svgs/apple-mono.svg',
                        width: 20,
                        height: 20,
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                AppleSignInSubmitted(),
                              );
                            },
                    ),
                    const SizedBox(height: 24),

                    // 4. Section Divider
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            color: Color(0xFFE5E5E0),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'or log in with email',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFFE5E5E0),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 5. Centralized Modular Credentials Form
                    BlocBuilder<LoginFormCubit, LoginFormState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              label: 'Email address',
                              hintText: 'you@example.com',
                              focusNode: _emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              errorText: state.email.errorMessage,
                              onChanged: context
                                  .read<LoginFormCubit>()
                                  .emailChanged,
                            ),
                            const SizedBox(height: 20),
                            AppTextField(
                              label: 'Password',
                              hintText: '•••••••••',
                              focusNode: _passwordFocusNode,
                              isPassword: true,
                              textInputAction: TextInputAction.done,
                              errorText: state.password.errorMessage,
                              onChanged: context
                                  .read<LoginFormCubit>()
                                  .passwordChanged,
                              onFieldSubmitted: (_) => _handleLogin(),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    // 6. Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.router.push(const ForgotPasswordRoute());
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF151515),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 7. Primary Action: Log in Button
                    AppButton(
                      text: 'Log in',
                      variant: AppButtonVariant.dark,
                      isLoading: isLoading,
                      trailing: const Icon(Icons.arrow_forward, size: 18),
                      onPressed: _handleLogin,
                    ),
                    const SizedBox(height: 28),

                    // 8. Footer Section
                    const Center(
                      child: Text(
                        'Your campus is waiting.',
                        style: TextStyle(
                          fontFamily: 'InstrumentSerif',
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF8E8E8A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          context.router.push(const SignUpRoute());
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'New around here?  ',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8E8E8A),
                            ),
                            children: [
                              TextSpan(
                                text: 'Create an account',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF151515),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'By continuing, you agree to our\nTerms of Use and Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          height: 1.4,
                          color: Color(0xFF8E8E8A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
