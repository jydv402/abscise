import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appPreferencesProvider = Provider<AppPreferences>((ref) {
  return AppPreferences();
});

class AppPreferences {
  static late final SharedPreferences _prefs;

  // Static initialization called once on app startup
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String _keyHasRequestedPerms = 'has_requested_perms';
  static const String _keyGoogleAuthSkipped = 'google_auth_skipped';
  static const String _keyMemorySaved = 'memory_saved';
  static const String _keyGoogleAuthenticated = 'google_authenticated';
  static const String _keyGoogleUserName = 'google_user_name';
  static const String _keyGoogleUserEmail = 'google_user_email';

  // Getters and Setters for has_requested_perms
  bool getHasRequestedPerms() {
    return _prefs.getBool(_keyHasRequestedPerms) ?? false;
  }

  Future<bool> setHasRequestedPerms(bool value) {
    return _prefs.setBool(_keyHasRequestedPerms, value);
  }

  // Getters and Setters for google_auth_skipped
  bool getGoogleAuthSkipped() {
    return _prefs.getBool(_keyGoogleAuthSkipped) ?? false;
  }

  Future<bool> setGoogleAuthSkipped(bool value) {
    return _prefs.setBool(_keyGoogleAuthSkipped, value);
  }

  // Getters and Setters for memory_saved
  double getMemorySaved() {
    return _prefs.getDouble(_keyMemorySaved) ?? 0.0;
  }

  Future<bool> setMemorySaved(double value) {
    return _prefs.setDouble(_keyMemorySaved, value);
  }

  // Getters and Setters for google_authenticated
  bool getGoogleAuthenticated() {
    return _prefs.getBool(_keyGoogleAuthenticated) ?? false;
  }

  Future<bool> setGoogleAuthenticated(bool value) {
    return _prefs.setBool(_keyGoogleAuthenticated, value);
  }

  // Getters and Setters for google_user_name
  String? getGoogleUserName() {
    return _prefs.getString(_keyGoogleUserName);
  }

  Future<bool> setGoogleUserName(String? value) {
    if (value == null) {
      return _prefs.remove(_keyGoogleUserName);
    }
    return _prefs.setString(_keyGoogleUserName, value);
  }

  // Getters and Setters for google_user_email
  String? getGoogleUserEmail() {
    return _prefs.getString(_keyGoogleUserEmail);
  }

  Future<bool> setGoogleUserEmail(String? value) {
    if (value == null) {
      return _prefs.remove(_keyGoogleUserEmail);
    }
    return _prefs.setString(_keyGoogleUserEmail, value);
  }
}
