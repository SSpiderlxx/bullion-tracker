import 'package:flutter/material.dart';

/// App-wide color constants for the Bullion Tracker design system.
///
/// Uses a premium finance-app palette with gold and silver accents
/// on dark backgrounds. Supports both dark and light themes.
sealed class AppColors {
  // Brand Colors
  static const Color gold = Color(0xFFFFD700);
  static const Color goldAccent = Color(0xFFC9A84C);
  static const Color goldDark = Color(0xFFB8860B);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color silverAccent = Color(0xFFA8A9AD);
  static const Color silverDark = Color(0xFF808080);

  // Brand Aliases (used across feature files)
  static const Color goldPrimary = gold;
  static const Color silverPrimary = silver;

  // Status Colors
  static const Color profit = Color(0xFF00C853);
  static const Color profitLight = Color(0xFF69F0AE);
  static const Color loss = Color(0xFFFF1744);
  static const Color lossLight = Color(0xFFFF8A80);
  static const Color neutral = Color(0xFF9E9E9E);

  // Dark Theme Colors
  static const Color backgroundDark = Color(0xFF0A0A0F);
  static const Color surfaceDark = Color(0xFF13131A);
  static const Color cardDark = Color(0xFF1C1C26);
  static const Color cardDarkAlt = Color(0xFF24243A);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFF9E9E9E);
  static const Color dividerDark = Color(0xFF2C2C3E);

  // Dark Theme Aliases
  static const Color darkBackground = backgroundDark;
  static const Color darkSurface = surfaceDark;
  static const Color darkCard = cardDark;
  static const Color darkTextPrimary = textPrimaryDark;
  static const Color darkTextSecondary = textSecondaryDark;

  // Light Theme Colors
  static const Color backgroundLight = Color(0xFFF5F5F7);
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Color(0xFFF8F8F8);
  static const Color textPrimaryLight = Color(0xFF1C1C1E);
  static const Color textSecondaryLight = Color(0xFF6C6C70);
  static const Color dividerLight = Color(0xFFE0E0E0);

  // Light Theme Aliases
  static const Color lightBackground = backgroundLight;
  static const Color lightSurface = surfaceLight;
  static const Color lightCard = cardLight;
  static const Color lightTextPrimary = textPrimaryLight;
  static const Color lightTextSecondary = textSecondaryLight;

  // Chart Colors
  static const Color chartGold = Color(0xFFFFD700);
  static const Color chartSilver = Color(0xFFC0C0C0);
  static const Color chartBlue = Color(0xFF2196F3);
  static const Color chartPurple = Color(0xFF9C27B0);

  // Gradient helpers
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFC9A84C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient silverGradient = LinearGradient(
    colors: [Color(0xFFC0C0C0), Color(0xFFA8A9AD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient profitGradient = LinearGradient(
    colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lossGradient = LinearGradient(
    colors: [Color(0xFFFF1744), Color(0xFFFF8A80)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1C1C26), Color(0xFF24243A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
