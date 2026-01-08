import 'package:flutter/material.dart';

/// [DesignTokens] defines the core visual constants for the application.
class DesignTokens {
  // Brand Colors - Spiritual & Premium
  /// The primary gold color representing value and purity.
  static const Color primaryGold = Color(0xFFD4AF37);

  /// A deep midnight blue for calmness and depth.
  static const Color midnightCalm = Color(0xFF1A237E);

  /// An ivory shade for a classic, nostalgic feel.
  static const Color antiqueIvory = Color(0xFFFDF5E6);

  /// Arose color representing affection ("Mouda").
  static const Color moudaRose = Color(0xFFE57373);

  /// A teal color representing tranquility ("Sakinah").
  static const Color sakinahTeal = Color(0xFF26A69A);

  // Backgrounds
  /// The main dark background color.
  static const Color darkBackground = Color(0xFF0F1429);

  /// The main light background color.
  static const Color lightBackground = antiqueIvory;

  // Effects
  /// Opacity level for glassmorphism effects.
  static const double glassOpacity = 0.8;

  /// Blur sigma for backdrop filters.
  static const double blurSigma = 15.0;

  /// Default border radius for cards and containers.
  static const double defaultRadius = 24.0;
}

/// [AppTheme] provides unified theme configuration for light and dark modes.
class AppTheme {
  /// Returns the configured dark theme data.
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: DesignTokens.primaryGold,
        scaffoldBackgroundColor: DesignTokens.darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: Colors.white.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.defaultRadius),
          ),
        ),
      );

  /// Returns the configured light theme data.
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: DesignTokens.primaryGold,
        scaffoldBackgroundColor: DesignTokens.lightBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: Colors.white.withValues(alpha: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.defaultRadius),
          ),
        ),
      );
}
