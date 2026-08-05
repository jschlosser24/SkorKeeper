// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    _UserPreferences(
      themeMode:
          $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      hapticEnabled: json['hapticEnabled'] as bool? ?? true,
      shakeToRollEnabled: json['shakeToRollEnabled'] as bool? ?? true,
      shakeSensitivity: (json['shakeSensitivity'] as num?)?.toDouble() ?? 15.0,
      defaultPlayerNames:
          (json['defaultPlayerNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$UserPreferencesToJson(_UserPreferences instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'soundEnabled': instance.soundEnabled,
      'hapticEnabled': instance.hapticEnabled,
      'shakeToRollEnabled': instance.shakeToRollEnabled,
      'shakeSensitivity': instance.shakeSensitivity,
      'defaultPlayerNames': instance.defaultPlayerNames,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
