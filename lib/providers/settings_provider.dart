import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDark => themeMode == ThemeMode.dark;

  void changeTheme(ThemeMode theme) {
    themeMode = theme;
    notifyListeners();
  }
}
