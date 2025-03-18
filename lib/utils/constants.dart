import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF3F51B5);
  static const primaryLight = Color(0xFF7986CB);
  static const primaryDark = Color(0xFF303F9F);
  static const accent = Color(0xFFFFA726);
  static const background = Color(0xFFF5F5F5);
  static const error = Color(0xFFE53935);
  static const success = Color(0xFF43A047);
  static const lightGrey = Color(0xFFEEEEEE);
}

class AppConstants {
  // Screen padding
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Duration options for course filtering (in weeks)
  static const Map<int, String> durationOptions = {
    4: 'Up to 1 month',
    8: 'Up to 2 months',
    12: 'Up to 3 months',
    26: 'Up to 6 months',
    52: 'Up to 1 year',
    100: 'Any duration',
  };

  // Learning levels
  static const List<String> learningLevels = [
    'any',
    'beginner',
    'intermediate',
    'advanced',
  ];

  // Learning styles
  static const List<String> learningStyles = [
    'any',
    'video',
    'interactive',
    'text',
    'project-based',
  ];

  // App routes
  static const String homeRoute = '/home';
  static const String welcomeRoute = '/';
  static const String detailRoute = '/detail';
  static const String preferencesRoute = '/preferences';
  static const String comparisonRoute = '/comparison';
  static const String searchRoute = '/search';
  static const String bookmarksRoute = '/bookmarks';

  // Search placeholder
  static const String searchPlaceholder = 'Search for courses, skills, instructors...';

  // Course cards per row (responsive)
  static const int coursesPerRowSmall = 2;
  static const int coursesPerRowMedium = 3;
  static const int coursesPerRowLarge = 4;

  // Animation durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
}