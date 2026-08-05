import 'package:flutter/material.dart';

import 'color_tokens.dart';
import 'text_styles.dart';

abstract class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: ColorTokens.navyPrimary,
        secondary: ColorTokens.lakeBlue,
        tertiary: ColorTokens.associationGreen,
        surface: ColorTokens.surfaceLight,
        onPrimary: ColorTokens.onPrimaryLight,
        onSurface: ColorTokens.onSurfaceLight,
      ),
      scaffoldBackgroundColor: ColorTokens.backgroundLight,
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
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ColorTokens.associationGreen,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorTokens.associationGreen;
          }
          return null;
        }),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: ColorTokens.lakeBlue,
        secondary: ColorTokens.moonlightSilver,
        tertiary: ColorTokens.associationGreen,
        surface: ColorTokens.surfaceDark,
        onPrimary: ColorTokens.onPrimaryDark,
        onSurface: ColorTokens.onSurfaceDark,
      ),
      scaffoldBackgroundColor: ColorTokens.backgroundDark,
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
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ColorTokens.associationGreen,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorTokens.associationGreen;
          }
          return null;
        }),
      ),
    );
  }
}
