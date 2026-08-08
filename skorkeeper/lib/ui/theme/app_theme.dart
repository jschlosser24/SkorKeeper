import 'package:flutter/material.dart';

import '../../core/monetization/theme_catalog.dart';
import '../../core/monetization/theme_definition.dart';
import 'text_styles.dart';

abstract class AppTheme {
  const AppTheme._();

  static ThemeData light([AppThemeDefinition? def]) {
    final scheme = (def ?? ThemeCatalog.defaultTheme).lightScheme;
    return _build(scheme, Brightness.light);
  }

  static ThemeData dark([AppThemeDefinition? def]) {
    final scheme = (def ?? ThemeCatalog.defaultTheme).darkScheme;
    return _build(scheme, Brightness.dark);
  }

  static ThemeData _build(ColorScheme scheme, Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isLight
          ? Color.lerp(scheme.surface, scheme.primary, 0.03)!
          : Color.lerp(scheme.surface, Colors.black, 0.15)!,
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.display,
        headlineMedium: AppTextStyles.headline,
        titleLarge: AppTextStyles.title,
        titleMedium: AppTextStyles.titleMedium,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.label,
        bodySmall: AppTextStyles.caption,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.tertiary,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.tertiary;
          }
          return null;
        }),
      ),
    );
  }
}
