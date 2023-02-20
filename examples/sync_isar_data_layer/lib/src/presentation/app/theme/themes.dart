
import 'package:flutter/material.dart';

import 'color_scheme.g.dart';

/// Themes for generated Material3 ThemeData.
///
/// Exposes a dark and a light theme option.
class Themes {
  /// DarkTheme
  static final darkTheme = ThemeData(brightness: Brightness.dark, colorScheme: darkColorScheme, useMaterial3: true);

  /// LightTheme
  static final lightTheme = ThemeData(brightness: Brightness.light, colorScheme: lightColorScheme, useMaterial3: true);
}
