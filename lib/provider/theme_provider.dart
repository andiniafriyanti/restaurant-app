import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const key = 'isDarkMode';
  bool isDarkMode = false;

  bool get isDark => isDarkMode;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool(key) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    isDarkMode = !isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, isDarkMode);
    notifyListeners();
  }
}
