import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Check if user is already signed in
  User? get currentUser => _auth.currentUser;
  
  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Generate a new 6-digit PIN
  String generatePin() {
    final rand = Random();
    return List.generate(6, (_) => rand.nextInt(10)).join();
  }

  // Create user and Firestore doc with PIN and send email verification link
  Future<User?> signUpWithEmail(String email, String password, {
    String? name,
    bool termsAgreed = false,
    bool privacyPolicyAgreed = false,
    bool childContentPolicyAgreed = false,
    bool isOver18 = false,
  }) async {
    User? user;
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      
      if (user != null) {
        // Generate PIN for backward compatibility
        final pin = generatePin();
        
        // Create user document in Firestore with all necessary fields
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'name': name,
          'pin': pin,
          'isVerified': false,
          'createdAt': FieldValue.serverTimestamp(),
          'termsAgreed': termsAgreed,
          'privacyPolicyAgreed': privacyPolicyAgreed,
          'childContentPolicyAgreed': childContentPolicyAgreed,
          'isOver18': isOver18,
          'hasCompletedOnboarding': false,
          'selectedChildProfileId': null,
        }, SetOptions(merge: true)); // Use merge to avoid overwriting existing data
        
        debugPrint('Created user document in Firestore for: $email');
        
        // Send email verification link
        await sendEmailVerificationLink(user);
      }
    } catch (e) {
      debugPrint('Error during sign up: $e');
      // If Firestore creation fails but Auth succeeded, delete the Auth user
      if (user != null) {
        try {
          await user.delete();
          debugPrint('Rolled back Firebase Auth user creation due to Firestore error');
        } catch (deleteError) {
          debugPrint('Error rolling back user creation: $deleteError');
        }
      }
      rethrow; // Re-throw the error to be handled by the UI
    }
    return user;
  }
  
  // Send email verification link
  Future<void> sendEmailVerificationLink(User user) async {
    try {
      await user.sendEmailVerification();
      debugPrint('Email verification link sent to ${user.email}');
    } catch (e) {
      debugPrint('Error sending email verification link: $e');
      rethrow;
    }
  }

  // Resend PIN (generate new one and update Firestore)
  Future<String?> resendPin(String uid) async {
    final pin = generatePin();
    await _firestore.collection('users').doc(uid).update({'pin': pin, 'isVerified': false});
    // TODO: Send PIN to user's email (for now, show on screen)
    return pin;
  }

  // Verify PIN
  Future<bool> verifyPin(String uid, String enteredPin) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data()?['pin'] == enteredPin) {
      await _firestore.collection('users').doc(uid).update({'isVerified': true});
      return true;
    }
    return false;
  }

  // Check if user is verified
  Future<bool> isUserVerified(String uid) async {
    try {
      // First check Firebase Auth email verification status
      final user = _auth.currentUser;
      if (user != null) {
        // Reload user to get the latest verification status
        await user.reload();
        if (user.emailVerified) {
          // If email is verified via Firebase, update Firestore
          await _firestore.collection('users').doc(uid).update({'isVerified': true});
          return true;
        }
      }
      
      // Fall back to checking Firestore for backward compatibility
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists && doc.data()?['isVerified'] == true;
    } catch (e) {
      debugPrint('Error checking user verification: $e');
      return false;
    }
  }
  
  // Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return userCredential.user;
    } catch (e) {
      debugPrint('Error signing in: $e');
      return null;
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Check if this is a new user and create Firestore document if needed
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if (!userDoc.exists) {
          // Create user document for new Google sign-in users
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'name': user.displayName,
            'photoURL': user.photoURL,
            'isVerified': true, // Google accounts are considered verified
            'createdAt': FieldValue.serverTimestamp(),
            'signInMethod': 'google',
            'hasCompletedOnboarding': false,
          }, SetOptions(merge: true));
          
          debugPrint('Created user document in Firestore for Google user: ${user.email}');
        }
      }

      return user;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return null;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
  
  // Delete user account and all associated data
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final uid = user.uid;
        
        // Delete user data from Firestore
        // 1. Delete user document
        await _firestore.collection('users').doc(uid).delete();
        
        // 2. Delete user's conversation history
        final conversationsQuery = await _firestore.collection('conversations')
            .where('userId', isEqualTo: uid).get();
        
        for (var doc in conversationsQuery.docs) {
          await doc.reference.delete();
        }
        
        // 3. Delete any other user-related collections as needed
        // Add more collection deletions here if necessary
        
        // Finally delete the Firebase Auth account
        await user.delete();
      }
    } catch (e) {
      debugPrint('Error deleting account: $e');
      rethrow;
    }
  }
  
  // Get current PIN for a user
  Future<String?> getCurrentPin(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data()?['pin'] as String?;
    }
    return null;
  }
}