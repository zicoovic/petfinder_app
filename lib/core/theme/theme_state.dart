import 'package:flutter/material.dart';

class ThemeState {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  /// Check if current theme is dark
  bool get isDark => themeMode == ThemeMode.dark;

  /// Check if current theme is light
  bool get isLight => themeMode == ThemeMode.light;

  /// Check if current theme follows system
  bool get isSystem => themeMode == ThemeMode.system;
}
