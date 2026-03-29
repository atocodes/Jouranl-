import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  SharedPreferences prefs;
  LocalStorageService(this.prefs);

  bool isSetupComplete() {
    return prefs.getBool(_LocalStorageKeys.hasCompletedSetup) ?? false;
  } // true, false or null

  Future<void> completeSetup() async {
    try {
      await prefs.setBool(_LocalStorageKeys.hasCompletedSetup, true);
    } catch (e) {
      rethrow;
    }
  }

  String getTheme() {
    final theme = prefs.getString(_LocalStorageKeys.theme);
    return theme ?? "dark";
  } // Light, dark or system

  Future<void> setTheme(String mode) async {
    try {
      await prefs.setString(_LocalStorageKeys.theme, mode);
    } catch (e) {
      rethrow;
    }
  }

  bool get isAutoPost => prefs.getBool(_LocalStorageKeys.autoPost) ?? false;

  Future<void> setAutoPost(bool value) async {
    try {
      await prefs.setBool(_LocalStorageKeys.autoPost, value);
    } catch (e) {
      rethrow;
    }
  }
}

class _LocalStorageKeys {
  static final String hasCompletedSetup = "hasCompletedSetup";
  static final String theme = "theme";
  static final String autoPost = "auto_post";
}
