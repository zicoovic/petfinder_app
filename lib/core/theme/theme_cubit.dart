import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder_app/core/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'app_theme';
  final SharedPreferences pref;
  ThemeCubit({required this.pref}) : super(_loadInitialTheme(pref));

  /// Load saved theme from SharedPreferences synchronously on init
  static ThemeState _loadInitialTheme(SharedPreferences pref) {
    try {
      final saved = pref.getString(_themeKey);
      ThemeMode mode;
      switch (saved) {
        case 'dark':
          mode = ThemeMode.dark;
          break;
        case 'light':
          mode = ThemeMode.light;
          break;
        default:
          mode = ThemeMode.system;
      }
      return ThemeState(themeMode: mode);
    } catch (e) {
      return const ThemeState(themeMode: ThemeMode.system);
    }
  }

  /// Toggle between light and dark theme (ignores system mode)

  Future<void> toggleTheme() async {
    final currentMode = state.themeMode;
    final newMode = currentMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await pref.setString(_themeKey, newMode.name);
    emit(ThemeState(themeMode: newMode));
  }

  /// Set specific theme mode
  Future<void> setTheme(ThemeMode mode) async {
    await pref.setString(_themeKey, mode.name);
    emit(ThemeState(themeMode: mode));
  }
}
