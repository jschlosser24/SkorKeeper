import 'package:flutter/material.dart';

import 'app_theme_id.dart';
import 'theme_definition.dart';

abstract class ThemeCatalog {
  const ThemeCatalog._();

  static const List<AppThemeDefinition> all = [
    _midnightWolves,
    _purpleReign,
    _sunsetBlitz,
    _arcticFox,
    _neonJungle,
    _royalCrimson,
    _oceanDeep,
    _goldenHour,
  ];

  static AppThemeDefinition get defaultTheme => _midnightWolves;

  static AppThemeDefinition? findById(AppThemeId id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  static const _midnightWolves = AppThemeDefinition(
    id: AppThemeId.midnightWolves,
    name: 'Midnight Wolves',
    description: 'The OG. Navy, lake blue, and championship green.',
    emoji: '🐺',
    isPro: false,
    previewPrimary: Color(0xFF0C2340),
    previewAccent: Color(0xFF78BE20),
    lightScheme: ColorScheme.light(
      primary: Color(0xFF0C2340),
      secondary: Color(0xFF7CB4DF),
      tertiary: Color(0xFF78BE20),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSurface: Color(0xFF0C2340),
    ),
    darkScheme: ColorScheme.dark(
      primary: Color(0xFF7CB4DF),
      secondary: Color(0xFF9EA2A2),
      tertiary: Color(0xFF78BE20),
      surface: Color(0xFF1A1A2E),
      onPrimary: Color(0xFF0C2340),
      onSurface: Color(0xFFE8E8E8),
    ),
  );

  static const _purpleReign = AppThemeDefinition(
    id: AppThemeId.purpleReign,
    name: 'Purple Reign',
    description: 'Bow down. Deep purple royalty.',
    emoji: '👑',
    isPro: true,
    previewPrimary: Color(0xFF221C35),
    previewAccent: Color(0xFF981D97),
    lightScheme: ColorScheme.light(
      primary: Color(0xFF221C35),
      secondary: Color(0xFF981D97),
      tertiary: Color(0xFFAB47BC),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSurface: Color(0xFF221C35),
      secondaryContainer: Color(0xFFEDD5F3),
      onSecondaryContainer: Color(0xFF3A0042),
    ),
    darkScheme: ColorScheme.dark(
      primary: Color(0xFFCE93D8),
      secondary: Color(0xFF981D97),
      tertiary: Color(0xFFE040FB),
      surface: Color(0xFF1E1528),
      onPrimary: Color(0xFF221C35),
      onSurface: Color(0xFFF3E5F5),
      secondaryContainer: Color(0xFF6A2675),
      onSecondaryContainer: Color(0xFFF3D5FA),
    ),
  );

  static const _sunsetBlitz = AppThemeDefinition(
    id: AppThemeId.sunsetBlitz,
    name: 'Sunset Blitz',
    description: 'Blazing heat. Go all night long.',
    emoji: '🌅',
    isPro: true,
    previewPrimary: Color(0xFFB03A00),
    previewAccent: Color(0xFFFFC107),
    lightScheme: ColorScheme.light(
      primary: Color(0xFFB03A00),
      secondary: Color(0xFFFF7043),
      tertiary: Color(0xFFFFC107),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSurface: Color(0xFF3E1200),
    ),
    darkScheme: ColorScheme.dark(
      primary: Color(0xFFFF8A65),
      secondary: Color(0xFFFFAB76),
      tertiary: Color(0xFFFFC107),
      surface: Color(0xFF2A1005),
      onPrimary: Color(0xFF3E1200),
      onSurface: Color(0xFFFFE0D0),
    ),
  );

  static const _arcticFox = AppThemeDefinition(
    id: AppThemeId.arcticFox,
    name: 'Arctic Fox',
    description: 'Ice cold. Chill out and crush the competition.',
    emoji: '🦊',
    isPro: true,
    previewPrimary: Color(0xFF004D6E),
    previewAccent: Color(0xFF00BCD4),
    lightScheme: ColorScheme.light(
      primary: Color(0xFF004D6E),
      secondary: Color(0xFF00ACC1),
      tertiary: Color(0xFF4DD0E1),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSurface: Color(0xFF002030),
    ),
    darkScheme: ColorScheme.dark(
      primary: Color(0xFF4DD0E1),
      secondary: Color(0xFF00BCD4),
      tertiary: Color(0xFF00E5FF),
      surface: Color(0xFF002233),
      onPrimary: Color(0xFF001B2E),
      onSurface: Color(0xFFE0F7FA),
    ),
  );

  static const _neonJungle = AppThemeDefinition(
    id: AppThemeId.neonJungle,
    name: 'Neon Jungle',
    description: 'Electric green energy. Dominate the night.',
    emoji: '🌿',
    isPro: true,
    previewPrimary: Color(0xFF1B5E20),
    previewAccent: Color(0xFF76FF03),
    lightScheme: ColorScheme.light(
      primary: Color(0xFF1B5E20),
      secondary: Color(0xFF4CAF50),
      tertiary: Color(0xFF76FF03),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSurface: Color(0xFF0A1F0A),
    ),
    darkScheme: ColorScheme.dark(
      primary: Color(0xFF76FF03),
      secondary: Color(0xFF4CAF50),
      tertiary: Color(0xFFCCFF90),
      surface: Color(0xFF111E11),
      onPrimary: Color(0xFF0A1F0A),
      onSurface: Color(0xFFF0FFF0),
    ),
  );

  static const _royalCrimson = AppThemeDefinition(
    id: AppThemeId.royalCrimson,
    name: 'Royal Crimson',
    description: 'Power and glory. Red for the bold.',
    emoji: '🔴',
    isPro: true,
    previewPrimary: Color(0xFF7B0000),
    previewAccent: Color(0xFFFFD700),
    lightScheme: ColorScheme.light(
      primary: Color(0xFF7B0000),
      secondary: Color(0xFFC62828),
      tertiary: Color(0xFFFFD700),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSurface: Color(0xFF3B0000),
    ),
    darkScheme: ColorScheme.dark(
      primary: Color(0xFFEF9A9A),
      secondary: Color(0xFFEF5350),
      tertiary: Color(0xFFFFD700),
      surface: Color(0xFF2A0505),
      onPrimary: Color(0xFF3B0000),
      onSurface: Color(0xFFFFEBEE),
    ),
  );

  static const _oceanDeep = AppThemeDefinition(
    id: AppThemeId.oceanDeep,
    name: 'Ocean Deep',
    description: 'Dive in. Smooth, deep, unstoppable.',
    emoji: '🌊',
    isPro: true,
    previewPrimary: Color(0xFF00565A),
    previewAccent: Color(0xFF26C6DA),
    lightScheme: ColorScheme.light(
      primary: Color(0xFF00565A),
      secondary: Color(0xFF00838F),
      tertiary: Color(0xFF26C6DA),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSurface: Color(0xFF001A1C),
    ),
    darkScheme: ColorScheme.dark(
      primary: Color(0xFF4DD0E1),
      secondary: Color(0xFF26C6DA),
      tertiary: Color(0xFF00E5FF),
      surface: Color(0xFF001E22),
      onPrimary: Color(0xFF001417),
      onSurface: Color(0xFFE0F7FA),
    ),
  );

  static const _goldenHour = AppThemeDefinition(
    id: AppThemeId.goldenHour,
    name: 'Golden Hour',
    description: 'Warm amber and rich brown. Play like a champion.',
    emoji: '🏆',
    isPro: true,
    previewPrimary: Color(0xFF5C3A00),
    previewAccent: Color(0xFFFFB300),
    lightScheme: ColorScheme.light(
      primary: Color(0xFF5C3A00),
      secondary: Color(0xFFAD6800),
      tertiary: Color(0xFFFFB300),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSurface: Color(0xFF2E1A00),
    ),
    darkScheme: ColorScheme.dark(
      primary: Color(0xFFFFB300),
      secondary: Color(0xFFFFCC44),
      tertiary: Color(0xFFFFE082),
      surface: Color(0xFF1E1200),
      onPrimary: Color(0xFF2E1A00),
      onSurface: Color(0xFFFFF8E1),
    ),
  );
}
