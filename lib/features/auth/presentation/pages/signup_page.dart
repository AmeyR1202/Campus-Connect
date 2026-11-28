import 'package:auto_route/auto_route.dart';
import 'package:campus_connect/core/routes/app_router.gr.dart';
import 'package:campus_connect/core/theme/app_colors.dart';
import 'package:campus_connect/core/widgets/app_back_button.dart';
import 'package:campus_connect/core/widgets/app_button.dart';
import 'package:campus_connect/core/widgets/app_text_field.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_event.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_state.dart';
import 'package:campus_connect/features/auth/presentation/cubit/sign_up_form_cubit.dart';
import 'package:campus_connect/features/auth/presentation/cubit/sign_up_form_state.dart';
import 'package:campus_connect/features/auth/presentation/widgets/social_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => SignUpFormCubit(), child: _SignUpView());
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    _nameFocusNode = FocusNode()
      ..addListener(() {
        if (!_nameFocusNode.hasFocus) {
          context.read<SignUpFormCubit>().nameUnfocused();
        }
      });
    _emailFocusNode = FocusNode()
      ..addListener(() {
        if (!_emailFocusNode.hasFocus) {
          context.read<SignUpFormCubit>().emailUnfocused();
        }
      });
    _passwordFocusNode = FocusNode()
      ..addListener(() {
        if (!_passwordFocusNode.hasFocus) {
          context.read<SignUpFormCubit>().passwordUnfocused();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    final cubit = context.read<SignUpFormCubit>();
    if (cubit.validate()) {
      context.read<AuthBloc>().add(
        SignUpSubmitted(
          username: cubit.state.name.value.trim(),
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
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'YOUR CAMPUS STARTS HERE',
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
                          'Make yourself\nat home.',
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
                          'Create your account. Find your community.',
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
                    const SizedBox(height: 24),

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
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color(0xFFE5E5E0),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'or sign up with email',
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
                    Column(
                      children: [
                        BlocBuilder<SignUpFormCubit, SignUpFormState>(
                          builder: (context, formState) {
                            return Column(
                              children: [
                                AppTextField(
                                  label: 'Your name',
                                  hintText: 'e.g. Alex',
                                  focusNode: _nameFocusNode,
                                  textInputAction: TextInputAction.next,
                                  errorText: formState.name.errorMessage,
                                  onChanged: context
                                      .read<SignUpFormCubit>()
                                      .nameChanged,
                                ),
                                const SizedBox(height: 20),
                                AppTextField(
                                  label: 'Email address',
                                  hintText: 'you@example.com',
                                  focusNode: _emailFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  errorText: formState.email.errorMessage,
                                  onChanged: context
                                      .read<SignUpFormCubit>()
                                      .emailChanged,
                                ),
                                const SizedBox(height: 20),
                                AppTextField(
                                  label: 'Password',
                                  hintText: '•••••••••',
                                  focusNode: _passwordFocusNode,
                                  isPassword: true,
                                  textInputAction: TextInputAction.done,
                                  errorText: formState.password.errorMessage,
                                  onChanged: context
                                      .read<SignUpFormCubit>()
                                      .passwordChanged,
                                  onFieldSubmitted: (_) => _handleSignUp(),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          text: 'Sign up',
                          variant: AppButtonVariant.dark,
                          isLoading: isLoading,
                          trailing: const Icon(Icons.arrow_forward, size: 18),
                          onPressed: _handleSignUp,
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'By continuing, you agree to our\nTerms of Use and Privacy Policy.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF8E8E8A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              context.router.replace(const LoginRoute());
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: Color(0xFF8E8E8A),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Log in',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.pureBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
