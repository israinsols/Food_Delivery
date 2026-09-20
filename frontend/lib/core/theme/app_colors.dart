import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Core Palette (Dark - default) ───
  static Color background = const Color(0xFF14100E);
  static Color surface = const Color(0xFF1E1712);
  static Color surfaceVariant = const Color(0xFF261E18);

  // Primary - Chili Orange (same in both themes)
  static const Color primary = Color(0xFFE8622C);
  static const Color primaryDark = Color(0xFFC94E1E);
  static const Color primaryLight = Color(0xFFFFB27A);

  // Gradient stops (same in both themes)
  static const Color gradientStart = Color(0xFFFFB27A);
  static const Color gradientEnd = Color(0xFFE8622C);
  static const Color gradientButtonStart = Color(0xFFE8622C);
  static const Color gradientButtonEnd = Color(0xFFC94E1E);

  // Secondary
  static Color secondary = const Color(0xFF2A2118);
  static Color secondaryLight = const Color(0xFF3D3228);

  // Text
  static Color textPrimary = const Color(0xFFF2E8E4);
  static Color textSecondary = const Color(0xFFA89E97);
  static Color textHint = const Color(0xFF6B6560);
  static const Color textOnPrimary = Colors.white;

  // Status (same in both themes)
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF4A9EF5);

  // Order Status (same in both themes)
  static const Color orderPending = Color(0xFFFF9800);
  static const Color orderPreparing = Color(0xFF4A9EF5);
  static const Color orderReady = Color(0xFF4CAF50);
  static const Color orderCompleted = Color(0xFF9E9E9E);
  static const Color orderCancelled = Color(0xFFF44336);

  // Table Status (same in both themes)
  static const Color tableAvailable = Color(0xFF4CAF50);
  static const Color tableOccupied = Color(0xFFF44336);
  static const Color tableReserved = Color(0xFFFF9800);
  static const Color tableCleaning = Color(0xFF9E9E9E);

  // Divider & Borders
  static Color divider = const Color(0xFF3D3228);
  static Color border = const Color(0xFF3D3228);
  static Color borderLight = const Color(0x14E8622C);

  // Glow colors (same in both themes)
  static const Color glowOrange = Color(0x3DE8622C);
  static const Color glowBlue = Color(0x3D4A9EF5);
  static const Color glowRed = Color(0x3DF44336);

  // Shadows (same in both themes)
  static const Color shadow = Color(0x40000000);
  static const Color glowShadow = Color(0x50E8622C);

  // ─── Theme Switching ───
  static void setDarkMode() {
    background = const Color(0xFF14100E);
    surface = const Color(0xFF1E1712);
    surfaceVariant = const Color(0xFF261E18);
    secondary = const Color(0xFF2A2118);
    secondaryLight = const Color(0xFF3D3228);
    textPrimary = const Color(0xFFF2E8E4);
    textSecondary = const Color(0xFFA89E97);
    textHint = const Color(0xFF6B6560);
    divider = const Color(0xFF3D3228);
    border = const Color(0xFF3D3228);
    borderLight = const Color(0x14E8622C);
  }

  static void setLightMode() {
    background = const Color(0xFFF5F3F0);
    surface = const Color(0xFFFFFFFF);
    surfaceVariant = const Color(0xFFF0ECEA);
    secondary = const Color(0xFFE8E2DE);
    secondaryLight = const Color(0xFFD9D2CD);
    textPrimary = const Color(0xFF1A1412);
    textSecondary = const Color(0xFF6B6560);
    textHint = const Color(0xFFA89E97);
    divider = const Color(0xFFE8E2DE);
    border = const Color(0xFFE8E2DE);
    borderLight = const Color(0x0DE8622C);
  }
}
