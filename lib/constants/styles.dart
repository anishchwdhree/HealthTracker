import 'package:flutter/material.dart';
import 'colors.dart';

class AppStyles {
  // Text styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Custom greeting style
  static const TextStyle greeting = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.25,
  );

  // Button styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    elevation: 2,
  );

  static final ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primaryColor,
    side: const BorderSide(color: AppColors.primaryColor, width: 2),
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  // Card styles
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardColor,
    borderRadius: BorderRadius.circular(20.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(10), // Lighter shadow
        blurRadius: 15,
        spreadRadius: 1,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Gradient card styles
  static final BoxDecoration gradientCardDecoration = BoxDecoration(
    gradient: const LinearGradient(
      colors: AppColors.primaryGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(20.0),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryColor.withAlpha(40),
        blurRadius: 15,
        spreadRadius: 1,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Calendar card style
  static final BoxDecoration calendarCardDecoration = BoxDecoration(
    color: AppColors.cardColor,
    borderRadius: BorderRadius.circular(20.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(10),
        blurRadius: 15,
        spreadRadius: 1,
        offset: const Offset(0, 4),
      ),
    ],
    border: Border.all(
      color: AppColors.secondaryColor.withAlpha(50),
      width: 1.5,
    ),
  );
}
