// Talks to firebaseAuth SDK

import 'package:firebase_auth/firebase_auth.dart';

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

  FirebaseAuthDataSourceImpl(this._firebaseAuth);

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
  Future<UserCredential> signInWithGoogle() {
    throw UnimplementedError('Google Sign-in will be configured next');
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
  Future<void> logOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    await user?.delete();
  }
}
