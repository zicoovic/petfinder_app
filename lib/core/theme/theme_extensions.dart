import 'package:flutter/material.dart';

/// Extension on BuildContext for easy theme access
extension ThemeExtensions on BuildContext {
  /// Quick access to text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Quick access to color scheme
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Quick access to theme data
  ThemeData get theme => Theme.of(this);
}
