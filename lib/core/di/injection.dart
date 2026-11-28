import 'package:campus_connect/core/routes/app_router.dart';
import 'package:campus_connect/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:campus_connect/features/auth/data/datasources/firestore_user_datasource.dart';
import 'package:campus_connect/features/auth/data/repositories/auth_repository_impl.dart';
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
import 'package:campus_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  /// 01. FEATURE AUTH

  /// 1. External dependencies (Firebase & Social Auth SDKs)
  await GoogleSignIn.instance.initialize();

  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);

  sl.registerLazySingleton(() => AppRouter()); // Flutter Auto Router
  // 2. DataSources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(sl(), sl()),
  );

  sl.registerLazySingleton<FirestoreUserDatasource>(
    () => FirestoreUserDatasourceImpl(sl()),
  );

  // 3. Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),

    /// LEARNED: forgot to give generic <AuthRepository> and app crashes with error
    /// "Object with type AuthRepository is not registered inside GetIt".
    /// As all the usecases request domain contract with AuthRepository
    /// Getit registers it under the concrete class AuthRepositoryImpl
    /// Critical Dependency Inversion Catch it is
    /// That is Dependency Inversion (the D in SOLID) in action:
    /// high-level use cases depend on the abstraction (AuthRepository),
    /// not the concrete implementation (AuthRepositoryImpl).
  );

  // 4. Usecases
  sl.registerLazySingleton(() => AppleSignInUsecase(sl()));
  sl.registerLazySingleton(() => CheckEmailVerifiedUsecase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUsecase(sl()));
  sl.registerLazySingleton(() => LogInUsecase(sl()));
  sl.registerLazySingleton(() => LogOutUsecase(sl()));
  sl.registerLazySingleton(() => SendEmailVerificationUsecase(sl()));
  sl.registerLazySingleton(() => SendPasswordResetEmailUsecase(sl()));
  sl.registerLazySingleton(() => SignUpUsecase(sl()));

  // 5. Presentation
  sl.registerFactory(
    () => AuthBloc(
      appleSignInUsecase: sl(),
      checkEmailVerifiedUsecase: sl(),
      deleteAccountUsecase: sl(),
      getCurrentUserUsecase: sl(),
      googleSignInUsecase: sl(),
      logInUsecase: sl(),
      logOutUsecase: sl(),
      sendEmailVerificationUsecase: sl(),
      sendPasswordResetEmailUsecase: sl(),
      signUpUsecase: sl(),
      authRepository: sl(),
    ),
  );
}
