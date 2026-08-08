import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preferences.freezed.dart';
part 'user_preferences.g.dart';

@freezed
abstract class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool soundEnabled,
    @Default(true) bool hapticEnabled,
    @Default(true) bool shakeToRollEnabled,
    @Default(15.0) double shakeSensitivity,
    @Default(<String>[]) List<String> defaultPlayerNames,
    @Default(<String>[]) List<String> defaultPlayerColors,
    @Default('midnightWolves') String selectedThemeId,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}
