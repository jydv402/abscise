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

  static const String _keyGooglePhotosConsentAccepted =
      'google_photos_consent_accepted';
  static const String _keyGooglePhotosConsentTimestamp =
      'google_photos_consent_timestamp';
  static const String _keyLocalConsentAccepted = 'local_consent_accepted';
  static const String _keyLocalConsentTimestamp = 'local_consent_timestamp';

  // Getters and Setters for Google Photos Consent
  bool getGooglePhotosConsentAccepted() {
    return _prefs.getBool(_keyGooglePhotosConsentAccepted) ?? false;
  }

  Future<bool> setGooglePhotosConsentAccepted(bool value) {
    return _prefs.setBool(_keyGooglePhotosConsentAccepted, value);
  }

  String? getGooglePhotosConsentTimestamp() {
    return _prefs.getString(_keyGooglePhotosConsentTimestamp);
  }

  Future<bool> setGooglePhotosConsentTimestamp(String? value) {
    if (value == null) {
      return _prefs.remove(_keyGooglePhotosConsentTimestamp);
    }
    return _prefs.setString(_keyGooglePhotosConsentTimestamp, value);
  }

  // Getters and Setters for Local Storage Consent
  bool getLocalConsentAccepted() {
    return _prefs.getBool(_keyLocalConsentAccepted) ?? false;
  }

  Future<bool> setLocalConsentAccepted(bool value) {
    return _prefs.setBool(_keyLocalConsentAccepted, value);
  }

  String? getLocalConsentTimestamp() {
    return _prefs.getString(_keyLocalConsentTimestamp);
  }

  Future<bool> setLocalConsentTimestamp(String? value) {
    if (value == null) {
      return _prefs.remove(_keyLocalConsentTimestamp);
    }
    return _prefs.setString(_keyLocalConsentTimestamp, value);
  }

  static const String _keyMediaFetchAscending = 'media_fetch_ascending';

  // Getters and Setters for Media Fetch Ordering (Ascending / Descending)
  bool getMediaFetchAscending() {
    return _prefs.getBool(_keyMediaFetchAscending) ?? true;
  }

  Future<bool> setMediaFetchAscending(bool value) {
    return _prefs.setBool(_keyMediaFetchAscending, value);
  }
}

class MediaFetchAscendingNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(appPreferencesProvider);
    return prefs.getMediaFetchAscending();
  }

  Future<void> setOrder(bool ascending) async {
    state = ascending;
    final prefs = ref.read(appPreferencesProvider);
    await prefs.setMediaFetchAscending(ascending);
  }
}

final mediaFetchAscendingProvider =
    NotifierProvider<MediaFetchAscendingNotifier, bool>(
      MediaFetchAscendingNotifier.new,
    );
