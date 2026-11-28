// Talks to firebaseAuth SDK

import 'dart:async';

import 'package:campus_connect/features/auth/domain/failures/auth_failures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract interface class FirebaseAuthDataSource {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<UserCredential> logInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithApple();
  Future<void> sendEmailVerification();
  Future<bool> reloadAndCheckEmailVerified();
  Future<void> sendPasswordResetEmail({required String email});
  Future<void> logOut();
  Future<void> deleteAccount();
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthDataSourceImpl(this._firebaseAuth, this._googleSignIn);

  // check if the curr logged in user sign in with google
  bool get _isGoogleProvider =>
      _firebaseAuth.currentUser?.providerData.any(
        (info) => info.providerId == GoogleAuthProvider.PROVIDER_ID,
      ) ??
      false;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Open the Google account picker (guarded against Android Credential Manager hangs)
      final account = await _googleSignIn.authenticate().timeout(
        const Duration(seconds: 45),
      );
      final idToken = account.authentication.idToken;

      if (idToken == null) {
        throw const AuthServerFailure(
          'Google sign-in failed: missing ID token.',
        );
      }

      // Trade the Google ID token for a Firebase credential
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      return await _firebaseAuth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const SocialSignInCancelledFailure();
      }
      throw AuthServerFailure(e.description ?? 'Google sign-in failed.');
    } on TimeoutException {
      throw const AuthServerFailure(
        'Google sign-in timed out. Please try again.',
      );
    }
  }

  @override
  Future<UserCredential> signInWithApple() {
    throw UnimplementedError('Apple Sign-in will be configured next');
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    await user?.sendEmailVerification();
  }

  @override
  Future<bool> reloadAndCheckEmailVerified() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.reload();
      return _firebaseAuth.currentUser?.emailVerified ?? false;
    }
    return false;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> logOut() async {
    final signOutGoogle = _isGoogleProvider;
    await Future.wait([
      _firebaseAuth.signOut(),
      if (signOutGoogle) _googleSignIn.signOut(),
    ]);
  }

  @override
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    final disconnectGoogle = _isGoogleProvider;
    await user?.delete();
    if (disconnectGoogle) {
      await _googleSignIn.disconnect();
    }
  }
}
