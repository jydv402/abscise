import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/providers/shared_prefs_provider.dart';
import '../logic/google_auth_service.dart';
import '../state/google_auth_state.dart';

class GoogleAuthController extends Notifier<GoogleAuthState> {
  late final GoogleAuthService _authService;
  bool _isManualLogin = false;

  @override
  GoogleAuthState build() {
    _authService = GoogleAuthService();

    final prefs = ref.read(appPreferencesProvider);
    final alreadyAuthenticated = prefs.getGoogleAuthenticated();

    if (alreadyAuthenticated) {
      // Just initialize listeners, DO NOT run lightweight re-auth silently on app launch to prevent popups
      _authService.initialize(
        onEvent: _handleAuthEvent,
        onError: _handleAuthError,
      );
      return const GoogleAuthState(status: AuthStatus.authenticated);
    }

    // Sequence native initialization, bypass silent checks on start to prevent popups
    _authService.initialize(
      onEvent: _handleAuthEvent,
      onError: _handleAuthError,
    );

    return const GoogleAuthState(status: AuthStatus.unauthenticated);
  }

  void _handleAuthEvent(GoogleSignInAuthenticationEvent event) async {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      final user = event.user;

      // Check if they granted our custom Photos scopes
      final hasScopes = await _authService.checkScopeAuthorization(user);

      if (hasScopes) {
        // Cache authenticated session in SharedPreferences
        final prefs = ref.read(appPreferencesProvider);
        await prefs.setGoogleAuthenticated(true);
        await prefs.setGoogleUserName(user.displayName);
        await prefs.setGoogleUserEmail(user.email);
        await prefs.setGooglePhotosConsentAccepted(true);
        await prefs.setGooglePhotosConsentTimestamp(DateTime.now().toUtc().toIso8601String());

        state = GoogleAuthState(status: AuthStatus.authenticated, user: user);
      } else if (_isManualLogin) {
        // Automatically request photos scopes during manual login if not already authorized
        final success = await _authService.requestPhotosScopes(user);
        if (success) {
          // Cache authenticated session in SharedPreferences
          final prefs = ref.read(appPreferencesProvider);
          await prefs.setGoogleAuthenticated(true);
          await prefs.setGoogleUserName(user.displayName);
          await prefs.setGoogleUserEmail(user.email);
          await prefs.setGooglePhotosConsentAccepted(true);
          await prefs.setGooglePhotosConsentTimestamp(DateTime.now().toUtc().toIso8601String());

          state = GoogleAuthState(status: AuthStatus.authenticated, user: user);
        } else {
          state = GoogleAuthState(
            status: AuthStatus.unauthenticated,
            user: user,
            errorMsg: 'Photos access authorization needed.',
          );
        }
      } else {
        // Background silent check failed or scopes missing
        state = GoogleAuthState(status: AuthStatus.unauthenticated, user: user);
      }
    } else if (event is GoogleSignInAuthenticationEventSignOut) {
      // Clear cached session on logout
      final prefs = ref.read(appPreferencesProvider);
      await prefs.setGoogleAuthenticated(false);
      await prefs.setGoogleUserName(null);
      await prefs.setGoogleUserEmail(null);
      await prefs.setGooglePhotosConsentAccepted(false);
      await prefs.setGooglePhotosConsentTimestamp(null);

      state = const GoogleAuthState(status: AuthStatus.unauthenticated);
    }
    _isManualLogin = false; // Reset after handling event
  }

  void _handleAuthError(Object error) {
    state = GoogleAuthState(
      status: AuthStatus.unauthenticated,
      errorMsg: _isManualLogin ? 'Authentication error: $error' : null,
    );
    _isManualLogin = false; // Reset after handling error
  }

  Future<void> login() async {
    _isManualLogin = true;
    state = state.copyWith(status: AuthStatus.checking);
    try {
      await _authService.newAuth();
    } catch (e) {
      state = GoogleAuthState(
        status: AuthStatus.unauthenticated,
        errorMsg: e.toString(),
      );
      _isManualLogin = false;
    }
  }

  /// Attempts to silently re-authenticate the user if the native session is not initialized.
  /// This is called lazily before performing cloud-based REST API calls.
  Future<GoogleSignInAccount?> getAuthenticatedUser() async {
    final currentUser = state.user;
    if (currentUser != null) {
      return currentUser;
    }

    try {
      await _authService.backgroundAuth();
      // Wait briefly for the event listener to catch and set the state
      if (state.user != null) {
        return state.user;
      }
    } catch (e) {
      // Fail silently
    }
    return null;
  }

  // If the user already has a user account linked but needs to prompt the permission modal
  Future<void> requestPhotosPermission() async {
    final currentUser = state.user;
    if (currentUser != null) {
      final success = await _authService.requestPhotosScopes(currentUser);
      if (success) {
        state = GoogleAuthState(
          status: AuthStatus.authenticated,
          user: currentUser,
        );
      }
    }
  }

  Future<void> skip() async {
    final prefs = ref.read(appPreferencesProvider);
    await prefs.setGoogleAuthSkipped(true);
    state = const GoogleAuthState(status: AuthStatus.skipped);
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.checking);
    try {
      await _authService.logOut();
      // Reset the skipped flag so they can authenticate afresh if they choose to
      final prefs = ref.read(appPreferencesProvider);
      await prefs.setGoogleAuthSkipped(false);
      await prefs.setGoogleAuthenticated(false);
      await prefs.setGoogleUserName(null);
      await prefs.setGoogleUserEmail(null);
      await prefs.setGooglePhotosConsentAccepted(false);
      await prefs.setGooglePhotosConsentTimestamp(null);
      state = const GoogleAuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = GoogleAuthState(
        status: AuthStatus.unauthenticated,
        errorMsg: "Logout failed: $e",
      );
    }
  }
}

final googleAuthControllerProvider =
    NotifierProvider.autoDispose<GoogleAuthController, GoogleAuthState>(
      () => GoogleAuthController(),
    );
