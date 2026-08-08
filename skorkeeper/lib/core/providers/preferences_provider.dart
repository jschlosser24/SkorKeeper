import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_preferences.dart';
import 'prefs_keys.dart';

part 'preferences_provider.g.dart';

@Riverpod(keepAlive: true)
class PreferencesNotifier extends _$PreferencesNotifier {
  late SharedPreferences _prefs;

  @override
  Future<UserPreferences> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _load();
  }

  UserPreferences _load() {
    final themeModeStr = _prefs.getString(PrefsKeys.themeMode) ?? 'system';
    final themeMode = themeModeStr == 'light'
        ? ThemeMode.light
        : themeModeStr == 'dark'
        ? ThemeMode.dark
        : ThemeMode.system;
    final namesJson = _prefs.getString(PrefsKeys.defaultPlayerNames) ?? '[]';
    final names = List<String>.from(jsonDecode(namesJson) as List<dynamic>);
    final colorsJson = _prefs.getString(PrefsKeys.defaultPlayerColors) ?? '[]';
    final colors = List<String>.from(jsonDecode(colorsJson) as List<dynamic>);
    final selectedThemeId =
        _prefs.getString(PrefsKeys.selectedThemeId) ?? 'midnightWolves';
    final soundPackId =
        _prefs.getString(PrefsKeys.soundPackId) ?? 'classic';
    return UserPreferences(
      themeMode: themeMode,
      soundEnabled: _prefs.getBool(PrefsKeys.soundEnabled) ?? true,
      hapticEnabled: _prefs.getBool(PrefsKeys.hapticEnabled) ?? true,
      shakeToRollEnabled: _prefs.getBool(PrefsKeys.shakeToRollEnabled) ?? true,
      shakeSensitivity: _prefs.getDouble(PrefsKeys.shakeSensitivity) ?? 15.0,
      defaultPlayerNames: names,
      defaultPlayerColors: colors,
      selectedThemeId: selectedThemeId,
    );
  }

  String get currentSoundPackId =>
      _prefs.getString(PrefsKeys.soundPackId) ?? 'classic';

  Future<void> updateSoundPackId(String packId) async {
    await _prefs.setString(PrefsKeys.soundPackId, packId);
    // Trigger a state refresh so listeners rebuild.
    state = AsyncData(_current());
  }

  UserPreferences _current() => state.valueOrNull ?? _load();

  Future<void> updateThemeMode(ThemeMode mode) async {
    final value = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
        ? 'dark'
        : 'system';
    await _prefs.setString(PrefsKeys.themeMode, value);
    state = AsyncData(_current().copyWith(themeMode: mode));
  }

  Future<void> updateSoundEnabled(bool value) async {
    await _prefs.setBool(PrefsKeys.soundEnabled, value);
    state = AsyncData(_current().copyWith(soundEnabled: value));
  }

  Future<void> updateHapticEnabled(bool value) async {
    await _prefs.setBool(PrefsKeys.hapticEnabled, value);
    state = AsyncData(_current().copyWith(hapticEnabled: value));
  }

  Future<void> updateShakeEnabled(bool value) async {
    await _prefs.setBool(PrefsKeys.shakeToRollEnabled, value);
    state = AsyncData(_current().copyWith(shakeToRollEnabled: value));
  }

  Future<void> updateShakeSensitivity(double value) async {
    await _prefs.setDouble(PrefsKeys.shakeSensitivity, value);
    state = AsyncData(_current().copyWith(shakeSensitivity: value));
  }

  Future<void> updateDefaultPlayerNames(List<String> names) async {
    await _prefs.setString(PrefsKeys.defaultPlayerNames, jsonEncode(names));
    state = AsyncData(_current().copyWith(defaultPlayerNames: names));
  }

  Future<void> updateDefaultPlayerColors(List<String> colors) async {
    await _prefs.setString(PrefsKeys.defaultPlayerColors, jsonEncode(colors));
    state = AsyncData(_current().copyWith(defaultPlayerColors: colors));
  }

  Future<void> updateDefaultPlayers(List<String> names, List<String> colors) async {
    await _prefs.setString(PrefsKeys.defaultPlayerNames, jsonEncode(names));
    await _prefs.setString(PrefsKeys.defaultPlayerColors, jsonEncode(colors));
    state = AsyncData(_current().copyWith(defaultPlayerNames: names, defaultPlayerColors: colors));
  }

  Future<void> updateSelectedTheme(String themeId) async {
    await _prefs.setString(PrefsKeys.selectedThemeId, themeId);
    state = AsyncData(_current().copyWith(selectedThemeId: themeId));
  }
}
