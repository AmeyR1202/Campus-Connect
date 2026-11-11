import 'package:campus_connect/core/entities/user_entity.dart';
import 'package:campus_connect/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:campus_connect/features/auth/data/datasources/firestore_user_datasource.dart';
import 'package:campus_connect/features/auth/data/models/user_model.dart';
import 'package:campus_connect/features/auth/domain/failures/auth_failures.dart';
import 'package:campus_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _authDataSource;
  final FirestoreUserDatasource _userDataSource;

  AuthRepositoryImpl(this._authDataSource, this._userDataSource);

  @override
  Future<Either<AuthFailures, UserEntity>> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) {
    return _guard(() async {
      // create account in firebase
      final credential = await _authDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthServerFailure('Account creation failed.');
      }

      // set display name on firebase Auth user
      await firebaseUser.updateDisplayName(username);

      // model and save profile to cloud firestore
      final userModel = UserModel(
        userId: firebaseUser.uid,
        username: username,
        email: email,
        isEmailVerified: firebaseUser.emailVerified,
        createdAt: DateTime.now(),
      );

      await _userDataSource.createUserProfile(user: userModel);

      // Send verification email
      await _authDataSource.sendEmailVerification();

      return userModel;
    });
  }

  Future<Either<AuthFailures, T>> _guard<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on AuthFailures catch (failure) {
      return Left(failure);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthException(e));
    } on FirebaseException catch (e) {
      return Left(AuthServerFailure(e.message ?? 'A database error occurred.'));
    } catch (e) {
      return Left(AuthServerFailure(e.toString()));
    }
  }

  AuthFailures _mapFirebaseAuthException(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' ||
      'invalid-email' => const InvalidCredentialsFailure(),
      'email-already-in-use' => const EmailAlreadyInUseFailure(),
      'weak-password' => const WeakPasswordFailure(),
      'network-request-failed' => const AuthNetworkFailure(),
      _ => AuthServerFailure(e.message ?? 'Authentication failed.'),
    };
  }

  @override
  // TODO: implement authStateChanges
  Stream<UserEntity?> get authStateChanges => throw UnimplementedError();

  @override
  Future<Either<AuthFailures, bool>> checkEmailVerified() {
    // TODO: implement checkEmailVerified
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailures, Unit>> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailures, UserEntity?>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailures, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailures, Unit>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailures, Unit>> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailures, Unit>> sendPasswordResetEmail({
    required String email,
  }) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailures, UserEntity>> signInWithApple() {
    // TODO: implement signInWithApple
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailures, UserEntity>> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }
}
