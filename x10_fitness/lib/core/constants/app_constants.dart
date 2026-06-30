import 'package:flutter/material.dart';

/// Centralized color palette for X10 AI Fitness Coach.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF00C853); // energetic green
  static const Color primaryDark = Color(0xFF009624);
  static const Color secondary = Color(0xFFFF6D00); // motivational orange
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFFFA000);

  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);

  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF6B6B6B);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
}

/// Static app strings, route names and shared constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'X10 AI Fitness Coach';

  static const String medicalDisclaimer =
      'This app provides general fitness and educational guidance only. '
      'It is not a substitute for professional medical advice, diagnosis, '
      'or treatment. Always consult a qualified healthcare provider before '
      'starting any new exercise program, especially if you have an existing '
      'health condition or injury.';

  static const List<String> workoutCategories = [
    'Home Workout',
    'Gym Workout',
    'Weight Loss',
    'Weight Gain',
    'Strength',
    'HIIT',
    'Yoga',
    'Stretching',
    'Senior Fitness',
  ];

  static const List<String> difficultyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  static const List<String> recoveryCategories = [
    'Lower Back',
    'Neck',
    'Shoulder',
    'Knee',
    'Hip',
    'Sciatica',
    'Office Stretch',
    'Posture',
  ];
}
