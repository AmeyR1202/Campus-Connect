import 'package:auto_route/auto_route.dart';
import 'package:campus_connect/core/routes/app_router.gr.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_event.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_state.dart';
import 'package:campus_connect/features/auth/presentation/widgets/mail_sent_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage>
    with WidgetsBindingObserver {
  bool _navigatingToSignUp = false;
  String _cachedEmail = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<AuthBloc>().add(const CheckEmailVerifiedSubmitted());
    }
  }

  @override
  Widget build(BuildContext context) {
    final blocEmail = context.select<AuthBloc, String>(
      (bloc) => bloc.state.whenOrNull(unverified: (user) => user.email) ?? '',
    );
    if (blocEmail.isNotEmpty) {
      _cachedEmail = blocEmail;
    }

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          ModalRoute.of(context)?.isCurrent ?? false,
      listener: (context, state) {
        state.whenOrNull(
          failure: (failure) {
            _navigatingToSignUp = false;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(failure.message)));
          },
          unauthenticated: () {
            context.router.replaceAll([
              _navigatingToSignUp ? const SignUpRoute() : const LoginRoute(),
            ]);
          },
          authenticated: (_) {
            context.router.replaceAll([const AccountReadyRoute()]);
          },
        );
      },
      child: MailSentTemplate(
        graphicCaption: 'ONE LAST CONNECTION',
        eyebrow: 'VERIFY YOUR EMAIL',
        title: 'Check your inbox.',
        subtitle:
            "We've sent you a verification link. Open it to verify your email and join Campus Connect.",
        email: _cachedEmail,
        leftActionLabel: 'Resend email',
        onLeftActionTap: () {
          context.read<AuthBloc>().add(
            const SendEmailVerificationSubmitted(),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Verification email resent!')),
            );
        },
        rightActionLabel: 'Change email',
        onRightActionTap: () {
          _navigatingToSignUp = true;
          context.read<AuthBloc>().add(const DeleteAccountSubmitted());
        },
        onBackPressed: () {
          _navigatingToSignUp = false;
          context.read<AuthBloc>().add(const LogoutSubmitted());
        },
      ),
    );
  }
}
