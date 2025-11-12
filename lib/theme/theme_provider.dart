import 'package:flutter/material.dart';
import 'package:note_task/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  // initiali theme
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darktMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == darktMode) {
      _themeData = lightMode;
    } else {
      _themeData = darktMode;
    }
    notifyListeners();
  }
}
