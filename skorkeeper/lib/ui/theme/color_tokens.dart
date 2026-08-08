import 'package:flutter/material.dart';

abstract class ColorTokens {
  const ColorTokens._();

  // Timberwolves palette
  static const Color navyPrimary = Color(0xFF0C2340);
  static const Color lakeBlue = Color(0xFF7CB4DF);
  static const Color moonlightSilver = Color(0xFF9EA2A2);
  static const Color associationGreen = Color(0xFF78BE20);

  // Extended palette
  static const Color playerOrange = Color(0xFFFF6B35);
  static const Color playerGold = Color(0xFFFFD700);
  static const Color playerTeal = Color(0xFF00C0A0);
  static const Color playerRed = Color(0xFFE84855);
  static const Color playerPurple = Color(0xFF8338EC);
  static const Color princePrimary = Color(0xFF221C35);
  static const Color princeViolet = Color(0xFF981D97);

  // Light mode semantics
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF0C2340);

  // Dark mode semantics
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color backgroundDark = Color(0xFF0C2340);
  static const Color onPrimaryDark = navyPrimary;
  static const Color onSurfaceDark = Color(0xFFE8E8E8);
}
