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
}
