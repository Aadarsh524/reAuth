import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reauth/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/bloc/cubit/popular_auth_cubit.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
import 'package:reauth/bloc/cubit/recent_auth_cubit.dart';
import 'package:reauth/bloc/cubit/user_auth_cubit.dart';
import 'package:reauth/bloc/states/authentication_state.dart';

import 'package:reauth/firebase_options.dart';
import 'package:reauth/pages/auth/login_page.dart';
import 'package:reauth/pages/auth/master_pin_gate.dart';
import 'package:reauth/themes/themes.dart';
// ... other imports

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationCubit()),
        BlocProvider(create: (context) => UserAuthCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => PopularAuthCubit()),
        BlocProvider(create: (context) => RecentAuthCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ReAuth',
        theme: AppTheme.darkTheme,
        home: const InitialLoader(),
      ),
    );
  }
}

class InitialLoader extends StatelessWidget {
  const InitialLoader({super.key});

  Future<Widget> _getInitialPage(BuildContext context) async {
    final authCubit = context.read<AuthenticationCubit>();
    await authCubit.initialize(); // Ensure Firebase auth is initialized
    if (authCubit.state is Authenticated) {
      // Instead of returning DashboardPage directly,
      // return the master PIN gateway page.
      return const MasterPinGate();
    } else {
      return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialPage(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Initialization failed"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AuthenticationCubit>().initialize(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }
        return snapshot.data ?? const LoginPage();
      },
    );
  }
}
