import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themePreferenceKey = 'theme_mode';

  static Future<String?> getSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_themePreferenceKey);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> saveTheme(String themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_themePreferenceKey, themeMode);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> clearTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_themePreferenceKey);
    } catch (e) {
      return false;
    }
  }
}
