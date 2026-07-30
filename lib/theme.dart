import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DuchessTheme {
  // Color Palette
  static const Color primary = Color(0xFF7B5455);
  static const Color primaryContainer = Color(0xFFF4C2C2);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF734E4E);

  static const Color secondary = Color(0xFF5E604D);
  static const Color secondaryContainer = Color(0xFFE1E1C9);

  static const Color tertiary = Color(0xFF735C00);
  static const Color tertiaryContainer = Color(0xFFF1CA50);
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color goldDim = Color(0xFFE9C349);

  static const Color background = Color(0xFFFFF8F7);
  static const Color surface = Color(0xFFFFF8F7);
  static const Color surfaceContainer = Color(0xFFFFE9E7);
  static const Color surfaceContainerHigh = Color(0xFFFFE2DF);
  static const Color surfaceDim = Color(0xFFFFCFCA);

  static const Color onSurface = Color(0xFF3D0506);
  static const Color onSurfaceVariant = Color(0xFF504444);
  static const Color error = Color(0xFFBA1A1A);

  // Typography Styles using GoogleFonts
  static TextStyle displayTitle({Color color = primary}) => GoogleFonts.playfairDisplay(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: -0.5,
      );

  static TextStyle headlineLg({Color color = onSurface}) => GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
        fontStyle: FontStyle.italic,
      );

  static TextStyle bodyMain({Color color = onSurface}) => GoogleFonts.sourceSerif4(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle bodySm({Color color = onSurfaceVariant}) => GoogleFonts.sourceSerif4(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle labelCaps({Color color = primary}) => GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: color,
      );

  // Glassmorphic Decoration with Gold Filigree Border
  static BoxDecoration glassGoldBorder({
    double borderRadius = 12.0,
    Color bgOpacity = const Color(0xD9FFF8F7), // 85% opacity
  }) {
    return BoxDecoration(
      color: bgOpacity,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: goldAccent,
        width: 1.5,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x33D4AF37),
          blurRadius: 10,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  // Soft Parchment Card Decoration
  static BoxDecoration parchmentCard({
    double borderRadius = 8.0,
  }) {
    return BoxDecoration(
      color: surfaceContainer.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: primary.withValues(alpha: 0.3),
        width: 1,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1F7B5455),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: Colors.white,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: Color(0xFF636451),
        tertiary: tertiary,
        onTertiary: Colors.white,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: Color(0xFF6B5500),
        error: error,
        onError: Colors.white,
        surface: surface,
        onSurface: onSurface,
      ),
      textTheme: TextTheme(
        displayLarge: displayTitle(),
        headlineMedium: headlineLg(),
        bodyLarge: bodyMain(),
        bodyMedium: bodySm(),
        labelLarge: labelCaps(),
      ),
    );
  }
}
