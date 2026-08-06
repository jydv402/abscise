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
  static const String _keyMemorySaved = 'memory_saved';

  // Getters and Setters for has_requested_perms
  bool getHasRequestedPerms() {
    return _prefs.getBool(_keyHasRequestedPerms) ?? false;
  }

  Future<bool> setHasRequestedPerms(bool value) {
    return _prefs.setBool(_keyHasRequestedPerms, value);
  }

  // Getters and Setters for memory_saved
  double getMemorySaved() {
    return _prefs.getDouble(_keyMemorySaved) ?? 0.0;
  }

  Future<bool> setMemorySaved(double value) {
    return _prefs.setDouble(_keyMemorySaved, value);
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

  static const String _keyTutorialShownLocalScreen = 'tutorial_shown_local_screen';
  static const String _keyTutorialShownBinScreen = 'tutorial_shown_bin_screen';

  bool getTutorialShownLocalScreen() {
    return _prefs.getBool(_keyTutorialShownLocalScreen) ?? false;
  }

  Future<bool> setTutorialShownLocalScreen(bool value) {
    return _prefs.setBool(_keyTutorialShownLocalScreen, value);
  }

  bool getTutorialShownBinScreen() {
    return _prefs.getBool(_keyTutorialShownBinScreen) ?? false;
  }

  Future<bool> setTutorialShownBinScreen(bool value) {
    return _prefs.setBool(_keyTutorialShownBinScreen, value);
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

class MemorySavedNotifier extends Notifier<double> {
  @override
  double build() {
    final prefs = ref.watch(appPreferencesProvider);
    return prefs.getMemorySaved();
  }

  Future<void> addMemorySaved(double mb) async {
    state += mb;
    final prefs = ref.read(appPreferencesProvider);
    await prefs.setMemorySaved(state);
  }
}

final memorySavedProvider = NotifierProvider<MemorySavedNotifier, double>(
  MemorySavedNotifier.new,
);
