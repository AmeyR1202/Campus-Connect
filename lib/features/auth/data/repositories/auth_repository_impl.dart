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

  @override
  Stream<UserEntity?> get authStateChanges {
    return _authDataSource.authStateChanges.map((firebaseUser) {
      if (firebaseUser == null) return null;

      //fetch full profile from firestore and return it
      return UserModel.fromFirebaseUser(firebaseUser);
    });
  }

  @override
  Future<Either<AuthFailures, bool>> checkEmailVerified() {
    return _guard(() async {
      return await _authDataSource.reloadAndCheckEmailVerified();
    });
  }

  /// LEARNED: Order of Deletion - Must delete user profile first then firebase auth user
  /// Why? Once you delete the Firebase Auth user, the user is instantly unauthenticated (request.auth == null).
  /// If you then try to delete their Firestore document, Firestore Security Rules will throw a PERMISSION_DENIED
  /// crash because an unauthenticated user cannot delete database records!

  @override
  Future<Either<AuthFailures, Unit>> deleteAccount() {
    return _guard(() async {
      final user = _authDataSource.currentUser;
      if (user == null) {
        throw const UserNotFoundFailure('No user currently logged in');
      }
      // 1. FIRST DELETE FIRESTORE PROFILE
      await _userDataSource.deleteUserProfile(user.uid);

      // 2. DELETE THE FIREBASE AUTH ACCOUNT
      await _authDataSource.deleteAccount();

      return unit;
    });
  }

  @override
  Future<Either<AuthFailures, UserEntity?>> getCurrentUser() {
    return _guard(() async {
      final firebaseUser = _authDataSource.currentUser;
      if (firebaseUser == null) {
        return null; // means no active session
      }

      final userProfile = await _userDataSource.getUserProfile(
        firebaseUser.uid,
      );
      if (userProfile != null) {
        return userProfile.copyWith(
          isEmailVerified: firebaseUser.emailVerified,
        );
      }

      return UserModel.fromFirebaseUser(
        firebaseUser,
      ); // Factory to map from Firebase Auth's User object
    });
  }

  @override
  Future<Either<AuthFailures, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final credential = await _authDataSource.logInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw const AuthServerFailure('User not found.');
      }

      // fetch the full student profile
      final userProfile = await _userDataSource.getUserProfile(
        firebaseUser.uid,
      );

      if (userProfile != null) {
        // sync the latest verification status from firebase auth
        return userProfile.copyWith(
          isEmailVerified: firebaseUser.emailVerified,
        );
      }

      // Fallback
      return UserModel.fromFirebaseUser(firebaseUser);
    });
  }

  @override
  Future<Either<AuthFailures, Unit>> logout() {
    return _guard(() async {
      await _authDataSource.logOut();
      return unit;
    });
  }

  @override
  Future<Either<AuthFailures, Unit>> sendEmailVerification() {
    return _guard(() async {
      await _authDataSource.sendEmailVerification();
      return unit;
    });
  }

  @override
  Future<Either<AuthFailures, Unit>> sendPasswordResetEmail({
    required String email,
  }) {
    return _guard(() async {
      await _authDataSource.sendPasswordResetEmail(email: email);
      return unit;
    });
  }

  @override
  Future<Either<AuthFailures, UserEntity>> signInWithApple() {
    return _guard(() async {
      final credential = await _authDataSource.signInWithApple();
      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw const AuthServerFailure('Apple sign-in failed.');
      }

      final existingProfile = await _userDataSource.getUserProfile(
        firebaseUser.uid,
      );

      if (existingProfile != null) {
        return existingProfile;
      }

      final newStudent = UserModel(
        userId: firebaseUser.uid,
        username: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
        isEmailVerified: firebaseUser.emailVerified,
        createdAt: DateTime.now(),
      );

      await _userDataSource.createUserProfile(user: newStudent);
      return newStudent;
    });
  }

  @override
  Future<Either<AuthFailures, UserEntity>> signInWithGoogle() {
    return _guard(() async {
      // 1. Authenticate with google via datasource
      final credential = await _authDataSource.signInWithGoogle();
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthServerFailure('Google sign-in failed.');
      }

      // 2. check if user already exist in db
      final existingProfile = await _userDataSource.getUserProfile(
        firebaseUser.uid,
      );
      if (existingProfile != null) {
        return existingProfile;
      }

      // 3. New student: create profile in Firestore from Google info
      final newStudent = UserModel(
        userId: firebaseUser.uid,
        username: firebaseUser.displayName ?? 'username',
        email: firebaseUser.email ?? '',
        isEmailVerified: firebaseUser.emailVerified,
        createdAt: DateTime.now(),
      );

      await _userDataSource.createUserProfile(user: newStudent);
      return newStudent;
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
}
