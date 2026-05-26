import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Color Palette
  static const primaryColor = Color(0xFF6366F1); // Indigo
  static const secondaryColor = Color(0xFF8B5CF6); // Purple
  static const accentColor = Color(0xFFF59E0B); // Amber
  static const backgroundColor = Color(0xFF0F172A); // Dark slate
  static const surfaceColor = Color(0xFF1E293B); // Slate
  static const cardColor = Color(0xFF334155); // Light slate
  static const errorColor = Color(0xFFEF4444);
  static const successColor = Color(0xFF10B981);
  
  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const cardGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF334155)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const backgroundGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.white70,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white60,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        labelStyle: GoogleFonts.inter(color: Colors.white60),
        hintStyle: GoogleFonts.inter(color: Colors.white38),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }
  
  // Light Theme Colors
  static const lightBackgroundColor = Color(0xFFF1F5F9); // Slate 100
  static const lightSurfaceColor = Colors.white;
  static const lightTextColor = Color(0xFF0F172A); // Slate 900
  static const lightSecondaryTextColor = Color(0xFF475569); // Slate 600

  static const lightBackgroundGradient = LinearGradient(
    colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: lightSurfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextColor,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: lightBackgroundColor,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: lightTextColor,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: lightTextColor,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: lightTextColor,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightTextColor,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: lightTextColor,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: lightSecondaryTextColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: lightTextColor),
        titleTextStyle: GoogleFonts.inter(
          color: lightTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        labelStyle: GoogleFonts.inter(color: lightSecondaryTextColor),
        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
      ),
      cardTheme: CardThemeData(
        color: lightSurfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }
  
  // Helper method for glassmorphic containers in light mode
  static BoxDecoration lightGlassmorphicDecoration({
    Color? color,
    double borderRadius = 24,
    bool withBorder = true,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(borderRadius),
      border: withBorder
          ? Border.all(
              color: Colors.white,
              width: 1,
            )
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  // Helper method for glassmorphic containers
  static BoxDecoration glassmorphicDecoration({
    Color? color,
    double borderRadius = 24,
    bool withBorder = true,
  }) {
    return BoxDecoration(
      color: color ?? surfaceColor.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(borderRadius),
      border: withBorder
          ? Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            )
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
  
  // Helper method for gradient containers
  static BoxDecoration gradientDecoration({
    Gradient? gradient,
    double borderRadius = 24,
  }) {
    return BoxDecoration(
      gradient: gradient ?? primaryGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}
