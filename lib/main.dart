import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reauth/bloc/cubit/authentication_cubit.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
import 'package:reauth/bloc/cubit/popular_auth_cubit.dart';
import 'package:reauth/bloc/cubit/recent_auth_cubit.dart';
import 'package:reauth/bloc/cubit/user_auth_cubit.dart';
import 'package:reauth/pages/auth/login_page.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';
import 'package:reauth/themes/themes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialPage(BuildContext context) async {
    final authCubit = AuthenticationCubit();
    final isLoggedIn = await authCubit.isLoggedIn(); // Check login status

    if (isLoggedIn) {
      return const DashboardPage(); // If logged in, go to Dashboard
    } else {
      return const LoginPage(); // If not logged in, go to LoginPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserAuthCubit()),
        BlocProvider(create: (context) => PopularAuthCubit()),
        BlocProvider(create: (context) => RecentAuthCubit()),
        BlocProvider(create: (context) => AuthenticationCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ReAuth',
        theme: AppTheme.darkTheme,
        home: FutureBuilder<Widget>(
          future: _getInitialPage(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while determining the initial page
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              // Handle errors (optional)
              return const Scaffold(
                body: Center(
                  child: Text("An error occurred"),
                ),
              );
            }

            // Navigate to the resolved initial page
            return snapshot.data!;
          },
        ),
      ),
    );
  }
}
