import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/kyozo_button.dart';
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
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          // Add subtle texture background like Next.js design
          color: AppTheme.backgroundColor,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App header with gradient title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App logo with gradient text
                    const GradientHeading(
                      'KyozoSocial',
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isSignIn ? 'Welcome back!' : 'Join the creative universe',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                        fontWeight: FontWeight.w300,
                      ),
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
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                    ),
                    validator: (value) {
                      if (!_isSignIn && (value == null || value.isEmpty)) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                ],
                
                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
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
                  const SizedBox(height: 20),
                  
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
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
                
                const SizedBox(height: 16),
                
                // Forgot password
                if (_isSignIn)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to forgot password screen
                      },
                      child: Text(
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.accentPink,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                
                // Error message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.errorColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.errorColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                
                const SizedBox(height: 40),
                
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
                    KyozoButton(
                      text: _isSignIn ? 'Sign In' : 'Get Started',
                      onPressed: _signInOrSignUp,
                      loading: _isLoading,
                      fullWidth: true,
                      variant: KyozoButtonVariant.primary,
                      size: KyozoButtonSize.large,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // OR divider
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppTheme.borderColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondaryColor,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: AppTheme.borderColor)),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Google Sign-In button
                    KyozoButton(
                      text: 'Continue with Google',
                      onPressed: _isLoading ? null : _signInWithGoogle,
                      variant: KyozoButtonVariant.outline,
                      size: KyozoButtonSize.large,
                      fullWidth: true,
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Toggle between Sign In and Sign Up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isSignIn ? 'Don\'t have an account?' : 'Already have an account?',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Toggle between sign in and sign up modes
                            setState(() {
                              _isSignIn = !_isSignIn;
                              _errorMessage = null; // Clear error when switching
                            });
                          },
                          child: Text(
                            _isSignIn ? 'Sign Up' : 'Sign In',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.accentPink,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
