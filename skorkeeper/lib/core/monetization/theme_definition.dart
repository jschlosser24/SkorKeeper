import 'package:flutter/material.dart';

import 'app_theme_id.dart';

class AppThemeDefinition {
  const AppThemeDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.isPro,
    required this.lightScheme,
    required this.darkScheme,
    required this.previewPrimary,
    required this.previewAccent,
  });

  final AppThemeId id;
  final String name;
  final String description;
  final String emoji;
  final bool isPro;
  final ColorScheme lightScheme;
  final ColorScheme darkScheme;
  final Color previewPrimary;
  final Color previewAccent;

  ColorScheme schemeFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkScheme : lightScheme;
}
