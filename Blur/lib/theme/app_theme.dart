import 'package:flutter/material.dart';

class AppTheme {
  // ── Brand ──────────────────────────────────────────────────────────────────
  static const primary     = Color(0xFF3B5BDB);
  static const primaryDark = Color(0xFF2F4CC3);

  // ── Light palette ──────────────────────────────────────────────────────────
  static const navy        = Color(0xFF0D1B3E);
  static const pageGray    = Color(0xFFF2F3F7);
  static const borderGray  = Color(0xFFE5E7EB);
  static const textBlack   = Color(0xFF111827);
  static const textGray    = Color(0xFF6B7280);
  static const textLight   = Color(0xFF9CA3AF);

  // ── Tag colours ────────────────────────────────────────────────────────────
  static const red    = Color(0xFFEF4444);
  static const green  = Color(0xFF10B981);
  static const orange = Color(0xFFF97316);
  static const purple = Color(0xFF7C3AED);

  // ── Dark palette (Neutral - No Blue Tint) ──────────────────────────────────
  static const darkBg        = Color(0xFF0F0F0F);      // Pure dark background
  static const darkSurface   = Color(0xFF1A1A1A);      // Dark surface/bars
  static const darkCard      = Color(0xFF262626);      // Dark card background
  static const darkBorder    = Color(0xFF3F3F3F);      // Dark borders
  static const darkTextMain  = Color(0xFFFAFAFA);      // Pure white text
  static const darkTextSub   = Color(0xFFB3B3B3);      // Gray secondary text
  static const darkTextLight = Color(0xFF808080);      // Light gray for hints

  // ── Light Theme ────────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: pageGray,
        cardColor: Colors.white,
        dividerColor: borderGray,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: textBlack,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: primary,
          unselectedLabelColor: textGray,
          indicatorColor: primary,
          indicatorSize: TabBarIndicatorSize.label,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? primary : Colors.white),
          trackColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected)
                  ? primary.withOpacity(0.4)
                  : borderGray),
        ),
      );

  // ── Dark Theme (Pure Dark - No Blue) ───────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
          surface: darkSurface,
          surfaceContainer: darkCard,
          error: Colors.red,
        ),
        scaffoldBackgroundColor: darkBg,
        cardColor: darkCard,
        dividerColor: darkBorder,
        appBarTheme: const AppBarTheme(
          backgroundColor: darkSurface,
          foregroundColor: darkTextMain,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: primary,
          unselectedLabelColor: darkTextSub,
          indicatorColor: primary,
          indicatorSize: TabBarIndicatorSize.label,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? primary : darkTextSub),
          trackColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected)
                  ? primary.withOpacity(0.4)
                  : darkBorder),
        ),
      );
}

// ── Theme-aware colour helpers ─────────────────────────────────────────────────
extension ThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get bgPage    => isDark ? AppTheme.darkBg       : AppTheme.pageGray;
  Color get bgCard    => isDark ? AppTheme.darkCard      : Colors.white;
  Color get bgSurface => isDark ? AppTheme.darkSurface   : Colors.white;
  Color get border    => isDark ? AppTheme.darkBorder    : AppTheme.borderGray;
  Color get txtMain   => isDark ? AppTheme.darkTextMain  : AppTheme.textBlack;
  Color get txtSub    => isDark ? AppTheme.darkTextSub   : AppTheme.textGray;
  Color get txtLight  => isDark ? AppTheme.darkTextLight : AppTheme.textLight;
}