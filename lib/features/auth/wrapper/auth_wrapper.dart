import 'package:flutter/material.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../../../services/auth_service.dart';
import '../screens/signin_screen.dart';
import '../../home/screens/home_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  bool _isVerified = false;
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final user = _authService.currentUser;
    
    if (user != null) {
      // User is signed in, check if they're verified
      final isVerified = await _authService.isUserVerified(user.uid);
      
      setState(() {
        _isSignedIn = true;
        _isVerified = isVerified;
        _isLoading = false;
      });
      
      debugPrint('User is signed in: ${user.uid}');
      debugPrint('User is verified: $isVerified');
    } else {
      // No user is signed in
      setState(() {
        _isSignedIn = false;
        _isVerified = false;
        _isLoading = false;
      });
      
      debugPrint('No user is signed in');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show loading indicator while checking auth state
      return const Scaffold(
        body: AppLoadingIndicator(),
      );
    }
    
    if (_isSignedIn && _isVerified) {
      // User is signed in and verified, show home screen
      debugPrint('Routing to HomeScreen - user is authenticated');
      return const HomeScreen();
    } else {
      // User is not signed in or not verified, show sign in screen directly
      debugPrint('Routing to SignInScreen - user needs authentication');
      return const SignInScreen();
    }
  }
}
