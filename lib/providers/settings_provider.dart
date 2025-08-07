import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  String languageCode = 'ar';

  bool get isDark => themeMode == ThemeMode.dark;

  void changeTheme(ThemeMode theme) {
    themeMode = theme;
    notifyListeners();
  }

  void changeLanguage(String language) {
    if (languageCode == language) return;
    languageCode = language;
    notifyListeners();
  }
}
