import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../services/auth_service.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String uid;
  final String email;
  const VerifyEmailScreen({required this.uid, required this.email, super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final AuthService _authService = AuthService();
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _checkVerificationStatus();
  }

  Future<void> _checkVerificationStatus() async {
    setState(() {
      _loading = true;
    });
    
    try {
      final isVerified = await _authService.isUserVerified(widget.uid);
      if (isVerified && mounted) {
        // User is already verified, navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }
    } catch (e) {
      debugPrint('Error checking verification status: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _verify() async {
    setState(() { 
      _loading = true; 
      _error = null; 
    });
    
    try {
      // Force refresh the user to get the latest verification status
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.reload();
      }
      
      // Check if user is already verified
      final isVerified = await _authService.isUserVerified(widget.uid);
      
      if (isVerified) {
        // User is verified, show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Email verified successfully!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          // Update user document to reflect verification
          await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
            'isVerified': true,
            'emailVerifiedAt': FieldValue.serverTimestamp(),
          });
          
          // Check if user has any child profiles
          debugPrint('Checking for child profiles for user: ${widget.uid}');
          final childProfilesSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .collection('childProfiles')
              .limit(1)
              .get();
          
          debugPrint('Found ${childProfilesSnapshot.docs.length} child profiles');
          
          // Short delay to show the success message before navigating
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              // Navigate to home screen after verification
              debugPrint('Email verified, navigating to home screen');
              Navigator.pushReplacementNamed(context, '/home');
            }
          });
        }
      } else {
        // User is not verified, show message with option to resend
        setState(() { 
          _error = "Your email is not verified yet. Please check your inbox or spam folder and click the verification link."; 
        });
        
        // Show a more detailed dialog with options
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Email Not Verified'),
              content: const Text(
                'Your email has not been verified yet. Please check your inbox and spam folder for the verification link.\n\n'
                'If you cannot find the email, you can request a new verification link.'
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _resend(); // Call the resend method
                  },
                  child: const Text('Resend Link'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      String errorMessage = "Error checking verification status";
      
      // Handle specific Firebase errors
      if (e.toString().contains('network-request-failed')) {
        errorMessage = "Network error. Please check your connection and try again.";
      } else if (e.toString().contains('user-not-found')) {
        errorMessage = "User account not found. Please try signing in again.";
      }
      
      setState(() { _error = errorMessage; });
    } finally {
      if (mounted) {
        setState(() { _loading = false; });
      }
    }
  }

  Future<void> _resend() async {
    setState(() { 
      _loading = true; 
      _error = null; 
    });
    
    try {
      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        // Check if we're within Firebase's rate limit (don't send too many emails)
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
        final lastEmailSent = userDoc.data()?['lastVerificationEmailSent'];
        
        if (lastEmailSent != null) {
          final lastSentTime = (lastEmailSent as Timestamp).toDate();
          final now = DateTime.now();
          final difference = now.difference(lastSentTime).inMinutes;
          
          // Firebase typically has a rate limit of 1 email per minute
          if (difference < 1) {
            setState(() { 
              _error = "Please wait a moment before requesting another email."; 
              _loading = false;
            });
            return;
          }
        }
        
        // Send email verification link
        await _authService.sendEmailVerificationLink(user);
        
        // Update last sent timestamp in Firestore
        await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
          'lastVerificationEmailSent': FieldValue.serverTimestamp(),
        });
        
        setState(() {
          _error = null;
        });
        
        // Show a snackbar confirmation
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Verification email sent to ${widget.email}"),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        setState(() { _error = "User not found. Please try signing in again."; });
      }
    } catch (e) {
      String errorMessage = "Error sending verification email";
      
      // Handle specific Firebase errors
      if (e.toString().contains('too-many-requests')) {
        errorMessage = "Too many requests. Please try again later.";
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = "Network error. Please check your connection.";
      }
      
      setState(() { _error = errorMessage; });
    } finally {
      if (mounted) {
        setState(() { _loading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title - centered at the top
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                child: AppHeading(
                  text: "Verify your email",
                  size: HeadingSize.medium,
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Email verification icon using image
              Image.asset(
                'assets/images/email_env.png',
                width: 80,
                height: 80,
                color: AppColors.primaryPurple,
              ),
              const SizedBox(height: 40),
              
              // Main text
              AppBodyText(
                text: "We've sent a verification link to",
                size: BodyTextSize.large,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              // Email address
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.divider),
                ),
                child: AppBodyText(
                  text: widget.email,
                  size: BodyTextSize.large,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              
              // Instructions
              AppBodyText(
                text: "Please check your email &\nclick on the link to continue.",
                size: BodyTextSize.medium,
                color: AppColors.primaryPurpleLight,
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // After verifying text
              AppBodyText(
                text: "After verifying your email, click the\nbutton below to continue",
                size: BodyTextSize.medium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Error message
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AppErrorText(
                    text: _error!,
                    textAlign: TextAlign.center,
                  ),
                ),
              
              // Verify button
              AppPrimaryButton(
                text: "I've verified my Email",
                onPressed: _verify,
                isLoading: _loading,
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              
              // Haven't received email text and resend link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppBodyText(
                    text: "Haven't received an email? ",
                    size: BodyTextSize.small,
                  ),
                  AppTextButton(
                    text: "Resend verification link",
                    onPressed: _loading ? null : _resend,
                    color: AppColors.primaryPurple,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
