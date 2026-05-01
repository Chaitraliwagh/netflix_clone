import 'package:flutter/material.dart';

/// Central constants file for the Netflix app.
/// All colors, styles, spacing values defined here.
class NetflixColors {
  NetflixColors._();

  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF2A2A2A);
  static const Color primary = Color(0xFFE50914); // Netflix Red
  static const Color primaryDark = Color(0xFFB00710);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textMuted = Color(0xFF666666);
  static const Color shimmerBase = Color(0xFF1A1A1A);
  static const Color shimmerHighlight = Color(0xFF2A2A2A);
  static const Color cardShadow = Color(0x99000000);
  static const Color gradientStart = Colors.transparent;
  static const Color gradientEnd = Color(0xFF000000);
  static const Color ratingGold = Color(0xFFFFC107);
}

class NetflixSpacing {
  NetflixSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double sectionPadding = 20.0;
  static const double cardBorderRadius = 8.0;
  static const double cardWidth = 110.0;
  static const double cardHeight = 155.0;
  static const double bannerHeight = 520.0;
}

class NetflixTextStyles {
  NetflixTextStyles._();

  static const TextStyle bannerTitle = TextStyle(
    color: NetflixColors.textPrimary,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
  );

  static const TextStyle bannerSubtitle = TextStyle(
    color: NetflixColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    color: NetflixColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );

  static const TextStyle movieTitle = TextStyle(
    color: NetflixColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle caption = TextStyle(
    color: NetflixColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle rating = TextStyle(
    color: NetflixColors.ratingGold,
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle detailTitle = TextStyle(
    color: NetflixColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static const TextStyle detailBody = TextStyle(
    color: NetflixColors.textSecondary,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle navLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );
}

/// Netflix-themed ThemeData.
ThemeData netflixTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: NetflixColors.background,
    colorScheme: const ColorScheme.dark(
      primary: NetflixColors.primary,
      surface: NetflixColors.surface,
      onPrimary: Colors.white,
      onSurface: NetflixColors.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: NetflixColors.textPrimary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0A0A0A),
      selectedItemColor: NetflixColors.textPrimary,
      unselectedItemColor: NetflixColors.textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(color: NetflixColors.textPrimary),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: NetflixColors.textPrimary),
      bodyMedium: TextStyle(color: NetflixColors.textSecondary),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
