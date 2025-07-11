import 'package:flutter/material.dart';
import 'package:habbit_tracker/themes/dark_mode.dart';
import 'package:habbit_tracker/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // initially, lightMode
  ThemeData _themeData = lightMode;

  // get current theme
  ThemeData get themeData => _themeData;

  // is current theme dark mode
  bool get isDarkMode => _themeData == darkMode;

  // Set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
