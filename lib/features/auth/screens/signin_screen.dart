import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../services/auth_service.dart';
import 'verify_email_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSignIn = true; // Toggle between sign in and sign up modes

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signInOrSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      try {
        final user = _isSignIn 
          ? await _authService.signInWithEmail(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            )
          : await _authService.signUpWithEmail(
              _emailController.text.trim(),
              _passwordController.text.trim(),
              name: _nameController.text.trim(),
            );
        
        if (user != null) {
          // Check if user is verified
          final isVerified = await _authService.isUserVerified(user.uid);
          
          if (mounted) {
            if (isVerified) {
              // First ensure user document exists in Firestore
              final userDoc = await _firestore.collection('users').doc(user.uid).get();
              
              if (!userDoc.exists) {
                debugPrint('User document not found in Firestore, creating it...');
                // Create user document with necessary fields
                await _firestore.collection('users').doc(user.uid).set({
                  'email': user.email,
                  'isVerified': true,
                  'createdAt': FieldValue.serverTimestamp(),
                  'hasCompletedOnboarding': false,
                }, SetOptions(merge: true));
                debugPrint('Created user document in Firestore for: ${user.email}');
              }
              
              // Navigate to home screen
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              // User needs to verify their email - navigate directly to verification screen
              setState(() {
                _isLoading = false;
              });
              
              // Navigate directly to the verification screen without showing a dialog
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => VerifyEmailScreen(
                    uid: user.uid,
                    email: user.email ?? _emailController.text.trim(),
                  ),
                ),
              );
            }
          }
        } else {
          setState(() {
            _errorMessage = 'Invalid email or password';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = _getReadableErrorMessage(e.toString());
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
  
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.signInWithGoogle();
      
      if (user != null && mounted) {
        // Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _errorMessage = 'Google sign-in was cancelled';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign in with Google: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getReadableErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No user found with this email';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password';
    } else if (error.contains('invalid-email')) {
      return 'Please enter a valid email address';
    } else if (error.contains('user-disabled')) {
      return 'This account has been disabled';
    } else if (error.contains('email-already-in-use')) {
      return 'Email already registered. Please login or try another email.';
    } else {
      return 'An error occurred: $error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App header with title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App logo or title
                  Text(
                    'KyozoSocial',
                    style: AppStyles.headingLarge.copyWith(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isSignIn ? 'Welcome back!' : 'Create your account',
                    style: AppStyles.headingMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Main content in scrollable area
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                
                // Name field (only in sign-up mode)
                if (!_isSignIn) ...[                
                  AppTextField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    validator: (value) {
                      if (!_isSignIn && (value == null || value.isEmpty)) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                ],
                
                // Email field
                AppEmailField(
                  controller: _emailController,
                  labelText: 'Email ID',
                  customValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Password field
                AppPasswordField(
                  controller: _passwordController,
                  labelText: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (!_isSignIn && value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                
                // Confirm Password field (only in sign-up mode)
                if (!_isSignIn) ...[                
                  const SizedBox(height: 16),
                  
                  AppPasswordField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    validator: (value) {
                      if (!_isSignIn) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                      }
                      return null;
                    },
                  ),
                ],
                
                const SizedBox(height: 8),
                
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: AppTextButton(
                    text: 'Forgot Password?',
                    onPressed: () {
                      // Navigate to forgot password screen
                    },
                    color: AppColors.primaryPurple,
                  ),
                ),
                
                // Error message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: AppErrorText(
                      text: _errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                
                const SizedBox(height: 32),
                
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Bottom section with Sign In button and Sign Up link
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Sign In/Sign Up button
                  SizedBox(
                    height: 56, // Increased height for better text display
                    child: AppPrimaryButton(
                      text: _isSignIn ? 'Sign In' : 'Get Started',
                      onPressed: _signInOrSignUp,
                      isLoading: _isLoading,
                      width: double.infinity,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // OR divider
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: AppStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Google Sign-In button
                  SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _signInWithGoogle,
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                        size: 20,
                      ),
                      label: Text(
                        'Continue with Google',
                        style: AppStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Toggle between Sign In and Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppBodyText(
                        text: _isSignIn ? 'Don\'t have an account?' : 'Already have an account?',
                        size: BodyTextSize.medium,
                      ),
                      AppTextButton(
                        text: _isSignIn ? 'Sign Up' : 'Sign In',
                        onPressed: () {
                          // Toggle between sign in and sign up modes
                          setState(() {
                            _isSignIn = !_isSignIn;
                          });
                        },
                        color: AppColors.primaryPurple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
