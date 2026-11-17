import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:campus_connect/core/entities/user_entity.dart';
import 'package:campus_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:campus_connect/features/auth/domain/usecases/apple_sign_in_usecase.dart';
import 'package:campus_connect/features/auth/domain/usecases/check_email_verified_usecase.dart';
import 'package:campus_connect/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:campus_connect/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:campus_connect/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:campus_connect/features/auth/domain/usecases/log_in_usecase.dart';
import 'package:campus_connect/features/auth/domain/usecases/log_out_usecase.dart';
import 'package:campus_connect/features/auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:campus_connect/features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:campus_connect/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_event.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppleSignInUsecase _appleSignInUsecase;
  final CheckEmailVerifiedUsecase _checkEmailVerifiedUsecase;
  final DeleteAccountUsecase _deleteAccountUsecase;
  final GetCurrentUserUsecase _getCurrentUserUsecase;
  final GoogleSignInUsecase _googleSignInUsecase;
  final LogInUsecase _logInUsecase;
  final LogOutUsecase _logOutUsecase;
  final SendEmailVerificationUsecase _sendEmailVerificationUsecase;
  final SendPasswordResetEmailUsecase _sendPasswordResetEmailUsecase;
  final SignUpUsecase _signUpUsecase;
  final AuthRepository _authRepository;
  StreamSubscription<UserEntity?>? _authSubscription;

  AuthBloc({
    required this._appleSignInUsecase,
    required this._checkEmailVerifiedUsecase,
    required this._deleteAccountUsecase,
    required this._getCurrentUserUsecase,
    required this._googleSignInUsecase,
    required this._logInUsecase,
    required this._logOutUsecase,
    required this._sendEmailVerificationUsecase,
    required this._sendPasswordResetEmailUsecase,
    required this._signUpUsecase,
    required this._authRepository,
  }) : super(const AuthState.initial()) {
    // 1. Splash Check
    on<AuthCheckRequested>(_onAuthCheckRequested);

    // 2. Forms with droppable to eliminate double taps
    on<LoginSubmitted>(_onLoginSubmitted, transformer: droppable());
    on<SignUpSubmitted>(_onSignUpSubmitted, transformer: droppable());
    on<GoogleSignInSubmitted>(
      _onGoogleSignInSubmitted,
      transformer: droppable(),
    );
    on<AppleSignInSubmitted>(_onAppleSignInSubmitted, transformer: droppable());
    // 3. Verification & Recovery
    on<SendEmailVerificationSubmitted>(_onSendEmailVerificationSubmitted);
    on<CheckEmailVerifiedSubmitted>(_onCheckEmailVerifiedSubmitted);
    on<SendPasswordResetSubmitted>(_onSendPasswordResetSubmitted);
    // 4. Session & Stream
    on<LogoutSubmitted>(_onLogoutSubmitted);
    on<AuthStateChanged>(_onAuthStateChanged);

    on<DeleteAccountSubmitted>(_onDeleteAccountSubmitted);

    // Subscribe to Firebase realtime stream
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthEvent.authStateChanged(user));
    });
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _getCurrentUserUsecase();
    result.fold(
      (failure) => emit(const AuthState.unauthenticated()),
      (user) => _handleUserRouting(user, emit),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _logInUsecase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthState.failure(failure)),
      (user) => _handleUserRouting(user, emit),
    );
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _signUpUsecase(
      username: event.username,
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthState.failure(failure)),
      (user) => _handleUserRouting(user, emit),
    );
  }

  Future<void> _onGoogleSignInSubmitted(
    GoogleSignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _googleSignInUsecase();
    result.fold(
      (failure) => emit(AuthState.failure(failure)),
      (user) => _handleUserRouting(user, emit),
    );
  }

  Future<void> _onAppleSignInSubmitted(
    AppleSignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _appleSignInUsecase();
    result.fold(
      (failure) => emit(AuthState.failure(failure)),
      (user) => _handleUserRouting(user, emit),
    );
  }

  Future<void> _onSendEmailVerificationSubmitted(
    SendEmailVerificationSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    await _sendEmailVerificationUsecase();
  }

  Future<void> _onCheckEmailVerifiedSubmitted(
    CheckEmailVerifiedSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _checkEmailVerifiedUsecase();
    result.fold((failure) => null, (isVerified) {
      if (isVerified) {
        state.maybeWhen(
          unverified: (user) => emit(
            AuthState.authenticated(user.copyWith(isEmailVerified: true)),
          ),
          orElse: () {},
        );
      }
    });
  }

  Future<void> _onSendPasswordResetSubmitted(
    SendPasswordResetSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    await _sendPasswordResetEmailUsecase(email: event.email);
  }

  Future<void> _onLogoutSubmitted(
    LogoutSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    await _logOutUsecase();
    emit(const AuthState.unauthenticated());
  }

  void _onAuthStateChanged(AuthStateChanged event, Emitter<AuthState> emit) {
    _handleUserRouting(event.user, emit);
  }

  void _handleUserRouting(UserEntity? user, Emitter<AuthState> emit) {
    if (user == null) {
      emit(const AuthState.unauthenticated());
    } else if (!user.isEmailVerified) {
      emit(AuthState.unverified(user));
    } else {
      emit(AuthState.authenticated(user));
    }
  }

  Future<void> _onDeleteAccountSubmitted(
    DeleteAccountSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _deleteAccountUsecase();
    result.fold(
      (failure) => emit(AuthState.failure(failure)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
