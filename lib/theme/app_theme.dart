import 'package:flutter/material.dart';

const int kMaxStarredApps = 5;

enum AppIconTheme {
  defaultTheme, // no filter — original icon colors
  dark, // desaturated + darkened — icons look dark/muted
  fun, // saturated + slightly warm tinted — vivid and bright
  cute, // soft pastel tint — light pink/purple overlay
}

/// Nocturnal OS Design System
/// Extracted from DESIGN.md and prototype.html
/// Dark-only theme with glassmorphism aesthetics

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// COLOR PALETTE (Material Design 3 inspired tokens)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class AppColors {
  // Primary - Electric Violet (moments of intent, brand-defining pulses)
  static const Color primary = Color(0xFFD2BBFF);
  static const Color primaryContainer = Color(0xFF7C3AED);
  static const Color onPrimary = Color(0xFF3F008E);
  static const Color onPrimaryContainer = Color(0xFFEDE0FF);

  // Secondary - Cyan/Teal (informational, cool high-tech contrast)
  static const Color secondary = Color(0xFF5DE6FF);
  static const Color secondaryContainer = Color(0xFF00CBE6);
  static const Color onSecondary = Color(0xFF00363E);
  static const Color onSecondaryContainer = Color(0xFF00515D);

  // Tertiary - Warm Orange (minimal usage in this design)
  static const Color tertiary = Color(0xFFFFB784);
  static const Color tertiaryContainer = Color(0xFFA15100);
  static const Color onTertiary = Color(0xFF4F2500);
  static const Color onTertiaryContainer = Color(0xFFFFE0CD);

  // Error
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onError = Color(0xFF690005);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // Surface layers ("stacked sheets of frosted sapphire")
  static const Color surface = Color(0xFF131318); // Base void
  static const Color surfaceDim = Color(0xFF131318);
  static const Color surfaceBright = Color(0xFF39383E);
  static const Color surfaceContainerLowest = Color(0xFF0E0E13);
  static const Color surfaceContainerLow = Color(0xFF1B1B20);
  static const Color surfaceContainer = Color(0xFF1F1F25);
  static const Color surfaceContainerHigh = Color(0xFF2A292F);
  static const Color surfaceContainerHighest = Color(0xFF35343A);
  static const Color surfaceVariant = Color(0xFF35343A);

  // Background
  static const Color background = Color(0xFF131318);

  // On-colors
  static const Color onSurface = Color(0xFFE4E1E9);
  static const Color onSurfaceVariant = Color(0xFFCCC3D8);
  static const Color onBackground = Color(0xFFE4E1E9);

  // Outline
  static const Color outline = Color(0xFF958DA1);
  static const Color outlineVariant = Color(0xFF4A4455);

  // Inverse
  static const Color inverseSurface = Color(0xFFE4E1E9);
  static const Color inverseOnSurface = Color(0xFF303036);
  static const Color inversePrimary = Color(0xFF732EE4);

  // Glass surface colors (used in glassmorphism widgets)
  static const Color glassDark = Color(0xB3131318); // rgba(19,19,24,0.7)
  static const Color glassLight = Color(0x08FFFFFF); // rgba(255,255,255,0.03)
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// TYPOGRAPHY
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class AppTypography {
  // Display & Headlines: Space Grotesk (bold, wide, unapologetic)
  static const String headline = 'Space Grotesk';

  // Body & Labels: Manrope (light, airy, geometric sans-serif)
  static const String body = 'Manrope';

  // Text styles based on prototype usage
  static const TextStyle displayLarge = TextStyle(
    fontFamily: headline,
    fontSize: 64,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.5, // tracking-tighter
    height: 1.0,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: headline,
    fontSize: 48,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.0,
    height: 1.0,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: headline,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: headline,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: headline,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.0,
    height: 1.3,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: body,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    height: 1.3,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: body,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: body,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: body,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: body,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: body,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5, // tracking-widest for "expensive" feel
    height: 1.2,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: body,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.25,
    height: 1.2,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: body,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5, // +5% tracking
    height: 1.2,
  );
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// SPACING & RADII
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

class AppRadius {
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0; // Primary card radius
  static const double xl = 32.0;
  static const double full = 9999.0;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// THEME DATA
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ThemeData buildAppTheme({double fontScaleFactor = 1.0}) {
  TextTheme scaled(TextTheme theme) => theme
      .apply(bodyColor: AppColors.onSurface, displayColor: AppColors.onSurface)
      .copyWith(
        displayLarge: AppTypography.displayLarge.copyWith(
          fontSize: 64 * fontScaleFactor,
        ),
        displayMedium: AppTypography.displayMedium.copyWith(
          fontSize: 48 * fontScaleFactor,
        ),
        headlineLarge: AppTypography.headlineLarge.copyWith(
          fontSize: 32 * fontScaleFactor,
        ),
        headlineMedium: AppTypography.headlineMedium.copyWith(
          fontSize: 28 * fontScaleFactor,
        ),
        headlineSmall: AppTypography.headlineSmall.copyWith(
          fontSize: 20 * fontScaleFactor,
        ),
        titleLarge: AppTypography.titleLarge.copyWith(
          fontSize: 18 * fontScaleFactor,
        ),
        titleMedium: AppTypography.titleMedium.copyWith(
          fontSize: 16 * fontScaleFactor,
        ),
        bodyLarge: AppTypography.bodyLarge.copyWith(
          fontSize: 16 * fontScaleFactor,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          fontSize: 14 * fontScaleFactor,
        ),
        bodySmall: AppTypography.bodySmall.copyWith(
          fontSize: 12 * fontScaleFactor,
        ),
        labelLarge: AppTypography.labelLarge.copyWith(
          fontSize: 14 * fontScaleFactor,
        ),
        labelMedium: AppTypography.labelMedium.copyWith(
          fontSize: 12 * fontScaleFactor,
        ),
        labelSmall: AppTypography.labelSmall.copyWith(
          fontSize: 10 * fontScaleFactor,
        ),
      );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.inverseOnSurface,
      inversePrimary: AppColors.inversePrimary,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: scaled(const TextTheme()),
    iconTheme: const IconThemeData(color: AppColors.onSurface, size: 24),
    cardTheme: CardThemeData(
      color: AppColors.surfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimaryContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: AppTypography.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        borderSide: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        borderSide: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.outline),
    ),
  );
}
