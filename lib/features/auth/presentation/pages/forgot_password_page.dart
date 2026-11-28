import 'package:auto_route/auto_route.dart';
import 'package:campus_connect/core/forms/email_input.dart';
import 'package:campus_connect/core/theme/app_colors.dart';
import 'package:campus_connect/core/widgets/app_back_button.dart';
import 'package:campus_connect/core/widgets/app_button.dart';
import 'package:campus_connect/core/widgets/app_text_field.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_event.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_state.dart';
import 'package:campus_connect/features/auth/presentation/widgets/mail_sent_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final FocusNode _emailFocusNode;
  EmailInput _email = const EmailInput.pure();
  bool _submitted = false;
  bool _linkSent = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode()
      ..addListener(() {
        if (!_emailFocusNode.hasFocus && _email.isPure) {
          setState(() => _email = EmailInput.dirty(_email.value));
        }
      });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    setState(() {
      _email = _email.isPure
          ? EmailInput.pure(value)
          : EmailInput.dirty(value);
    });
  }

  void _handleSubmit() {
    final dirtyEmail = EmailInput.dirty(_email.value);
    setState(() => _email = dirtyEmail);

    if (dirtyEmail.isValid) {
      _submitted = true;
      context.read<AuthBloc>().add(
        SendPasswordResetSubmitted(email: dirtyEmail.value.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthBloc, bool>(
      (bloc) => bloc.state.maybeWhen(loading: () => true, orElse: () => false),
    );

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          ModalRoute.of(context)?.isCurrent ?? false,
      listener: (context, state) {
        state.whenOrNull(
          failure: (failure) {
            _submitted = false;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(failure.message)));
          },
          unauthenticated: () {
            if (_submitted) {
              setState(() {
                _submitted = false;
                _linkSent = true;
              });
            }
          },
        );
      },
      child: _linkSent
          ? MailSentTemplate(
              graphicCaption: 'YOUR WAY BACK IN',
              eyebrow: 'RESET LINK SENT',
              title: 'Mail on its way.',
              subtitle:
                  'Check your inbox for a password-reset link. Follow the link to choose a new password.',
              email: _email.value.trim(),
              leftActionLabel: 'Resend reset link',
              onLeftActionTap: () {
                context.read<AuthBloc>().add(
                  SendPasswordResetSubmitted(email: _email.value.trim()),
                );
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Reset link resent!')),
                  );
              },
              rightActionLabel: 'Back to log in',
              onRightActionTap: () => context.router.maybePop(),
              onBackPressed: () => setState(() => _linkSent = false),
            )
          : Scaffold(
        backgroundColor: AppColors.pureWhite,
        body: SafeArea(
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Top Navigation Bar
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
                      const SizedBox(height: 28),

                      // 2. Key Badge Icon
                      Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F3F1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.vpn_key_outlined,
                          size: 22,
                          color: Color(0xFF151515),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 3. Hero Headline Block
                      const Text(
                        "LET'S GET YOU BACK IN",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.4,
                          color: Color(0xFF666663),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Forgot your\npassword?',
                        style: TextStyle(
                          fontFamily: 'InstrumentSerif',
                          fontSize: 48,
                          height: 1.0,
                          letterSpacing: -0.5,
                          color: Color(0xFF151515),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "It happens. Enter your account email and we'll send you a link to reset your password.",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.45,
                          color: Color(0xFF666663),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // 4. Email Input
                      AppTextField(
                        label: 'Email address',
                        hintText: 'you@example.com',
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        errorText: _email.errorMessage,
                        onChanged: _onEmailChanged,
                        onFieldSubmitted: (_) => _handleSubmit(),
                      ),

                      const Spacer(),
                      const SizedBox(height: 24),

                      // 5. Primary CTA Button
                      AppButton(
                        text: 'Send reset link',
                        variant: AppButtonVariant.dark,
                        isLoading: isLoading,
                        trailing: const Icon(Icons.arrow_forward, size: 18),
                        onPressed: _handleSubmit,
                      ),
                      const SizedBox(height: 20),

                      // 6. Footer Links
                      Center(
                        child: GestureDetector(
                          onTap: () => context.router.maybePop(),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Remembered it?  ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Color(0xFF8E8E8A),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Back to log in',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF151515),
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF151515),
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
                          'A fresh start is just an email away.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.5,
                            color: Color(0xFF8E8E8A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
