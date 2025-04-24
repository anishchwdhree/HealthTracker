import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryColor = Color(0xFFE57697); // Soft pink
  static const Color secondaryColor = Color(0xFFF8BBD0); // Light pink
  static const Color accentColor = Color(0xFF9C27B0); // Purple
  static const Color tertiaryColor = Color(0xFF7986CB); // Indigo

  // Background colors
  static const Color backgroundColor = Color(0xFFFCE4EC); // Very light pink
  static const Color cardColor = Colors.white;
  static const Color surfaceColor = Color(0xFFFFF9FA); // Off-white with pink tint

  // Text colors
  static const Color textPrimary = Color(0xFF424242); // Dark grey
  static const Color textSecondary = Color(0xFF757575); // Medium grey
  static const Color textLight = Color(0xFFBDBDBD); // Light grey

  // Status colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color error = Color(0xFFE53935); // Red

  // Cycle-specific colors
  static const Color periodColor = Color(0xFFE57697); // Same as primary
  static const Color ovulationColor = Color(0xFF9575CD); // Purple
  static const Color fertileColor = Color(0xFF81C784); // Green
  static const Color symptomColor = Color(0xFFFFB74D); // Orange
  static const Color noteColor = Color(0xFF64B5F6); // Blue

  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFFE57697),
    Color(0xFFFF9CAE),
  ];

  static const List<Color> purpleGradient = [
    Color(0xFF9C27B0),
    Color(0xFFBA68C8),
  ];

  static const List<Color> blueGradient = [
    Color(0xFF1976D2),
    Color(0xFF64B5F6),
  ];
}
