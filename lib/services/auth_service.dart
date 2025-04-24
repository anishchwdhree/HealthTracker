import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This is a placeholder service that will be implemented with Firebase Auth
class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Current user
  String? _userId;
  String? get userId => _userId;

  bool get isAuthenticated => _userId != null;

  // Check if onboarding is completed
  Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('onboarding_completed_$_userId') ?? false;
    } catch (e) {
      debugPrint('Error accessing SharedPreferences: $e');
      // If we can't access SharedPreferences, assume onboarding is not completed
      return false;
    }
  }

  // Set onboarding completed status
  Future<void> setOnboardingCompleted(bool completed) async {
    if (_userId == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed_$_userId', completed);
      debugPrint('Onboarding completion status set to: $completed');
    } catch (e) {
      debugPrint('Error setting onboarding status: $e');
      // For now, we'll just log the error and continue
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // This will be implemented with Firebase Auth
    debugPrint('Signing in with email: $email');

    // Check for test credentials
    if (email == 'anishchwdhree@gmail.com' && password == '1@anish890') {
      // Test user authentication succeeds immediately
      _userId = 'test_user_id';
      return;
    }

    // For other credentials, simulate authentication delay
    await Future.delayed(const Duration(seconds: 2));

    // In a real implementation, we would validate credentials here
    // For now, we'll throw an error for any non-test credentials
    if (email != 'anishchwdhree@gmail.com' || password != '1@anish890') {
      throw Exception('Invalid email or password');
    }

    _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Create user with email and password
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    // This will be implemented with Firebase Auth
    debugPrint('Creating user with email: $email, name: $name');

    // For test account, simulate immediate success
    if (email == 'anishchwdhree@gmail.com' && password == '1@anish890') {
      _userId = 'test_user_id';
      return;
    }

    // Simulate user creation delay
    await Future.delayed(const Duration(seconds: 2));

    // In a real implementation, we would create a new user here
    // For now, we'll set the user ID for any credentials
    _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    // This will be implemented with Firebase Auth and Google Sign In
    debugPrint('Signing in with Google');

    // Simulate authentication
    await Future.delayed(const Duration(seconds: 2));
    _userId = 'google_user_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Sign out
  Future<void> signOut() async {
    // This will be implemented with Firebase Auth
    debugPrint('Signing out');

    // Simulate sign out
    await Future.delayed(const Duration(milliseconds: 500));
    _userId = null;
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    // This will be implemented with Firebase Auth
    debugPrint('Resetting password for email: $email');

    // Simulate password reset
    await Future.delayed(const Duration(seconds: 1));
  }
}
