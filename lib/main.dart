import 'package:campus_connect/core/di/injection.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:campus_connect/features/auth/presentation/bloc/auth_event.dart';
import 'package:campus_connect/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firebase initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Initialize Dependency Injection (GetIt)
  await initDependencies();
  runApp(const CampusConnect());
}

class CampusConnect extends StatelessWidget {
  const CampusConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AuthBloc>()..add(const AuthEvent.authCheckRequested()),
      child: MaterialApp(
        title: 'Campus Connect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: Center(child: Text('Firebase & DI Bootstrapped!')),
        ),
      ),
    );
  }
}
