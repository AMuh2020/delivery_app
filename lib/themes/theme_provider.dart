import 'package:flutter/material.dart';
import 'package:delivery_app/themes/dark_theme.dart';
import 'package:delivery_app/themes/light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = darkMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == darkMode) {
      setThemeData(lightMode);
    } else {
      setThemeData(darkMode);
    }
  }
}