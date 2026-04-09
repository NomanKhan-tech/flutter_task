import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color backgroundPrimary = Color(0xFF000000);
  static const Color backgroundCard = Color(0xFF1C1C1E);
  static const Color backgroundCardDark = Color(0xFF141414);
  static const Color backgroundSection = Color(0xFF1A1A1A);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textMuted = Color(0xFF636366);

  // Accent
  static const Color accentTeal = Color(0xFF3CCFB4);
  static const Color accentBlue = Color(0xFF5B6AF0);
  static const Color accentPurple = Color(0xFF8B78E6);
  static const Color accentGreen = Color(0xFF34C759);

  // Workout tag colors
  static const Color tagArms = Color(0xFF1E4D35);
  static const Color tagArmsText = Color(0xFF4CD964);
  static const Color tagLegs = Color(0xFF2D2B5E);
  static const Color tagLegsText = Color(0xFF8B78E6);

  // Divider
  static const Color divider = Color(0xFF2C2C2E);

  // Bottom nav
  static const Color navActive = Color(0xFFFFFFFF);
  static const Color navInactive = Color(0xFF636366);

  // Mood wheel gradient colors (going clockwise from top-right)
  static const List<Color> moodWheelColors = [
    Color(0xFF5ECFBA), // teal (top right)
    Color(0xFF8B9BE8), // periwinkle
    Color(0xFFB388D8), // lavender
    Color(0xFFD4A0C8), // mauve
    Color(0xFFE8A0A8), // pink
    Color(0xFFF0B898), // salmon
    Color(0xFFF0C878), // peach
    Color(0xFFE8B860), // orange
    Color(0xFFD49840), // amber
    Color(0xFF5ECFBA), // back to teal
  ];
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentTeal,
        surface: AppColors.backgroundCard,
      ),
      fontFamily: 'SF Pro Display',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundPrimary,
        selectedItemColor: AppColors.navActive,
        unselectedItemColor: AppColors.navInactive,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
      ),
    );
  }
}
