import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/wrapper/auth_wrapper.dart';
import 'features/auth/screens/signin_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'firebase_options.dart';

// Global navigation key for navigating from anywhere in the app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const KyozoSocialApp());
}

class KyozoSocialApp extends StatelessWidget {
  const KyozoSocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KyozoSocial',
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/signin':
            return MaterialPageRoute(builder: (context) => const SignInScreen());
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          default:
            return MaterialPageRoute(builder: (context) => const SignInScreen());
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}