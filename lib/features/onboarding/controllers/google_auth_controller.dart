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

    final prefs = ref.read(sharedPreferencesProvider);
    final alreadySkipped = prefs.getBool('google_auth_skipped') ?? false;

    if (alreadySkipped) {
      // Synchronously bypass onboarding screen to Home, while starting silent auth asynchronously in background
      _authService.initialize(
        onEvent: _handleAuthEvent,
        onError: _handleAuthError,
      ).then((_) {
        _checkSilentAuth();
      });
      return const GoogleAuthState(status: AuthStatus.skipped);
    }

    // Sequence silent check AFTER native initialization resolves to prevent race conditions
    _authService.initialize(
      onEvent: _handleAuthEvent,
      onError: _handleAuthError,
    ).then((_) {
      _checkSilentAuth();
    });

    return const GoogleAuthState(status: AuthStatus.checking);
  }

  void _checkSilentAuth() {
    _authService.backgroundAuth();
  }

  void _handleAuthEvent(GoogleSignInAuthenticationEvent event) async {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      final user = event.user;

      // Check if they granted our custom Photos scopes
      final hasScopes = await _authService.checkScopeAuthorization(user);

      if (hasScopes) {
        state = GoogleAuthState(status: AuthStatus.authenticated, user: user);
      } else {
        // Logged in, but hasn't authorized photos yet
        state = GoogleAuthState(
          status: AuthStatus.unauthenticated,
          user: user,
          errorMsg: _isManualLogin ? 'Photos access authorization needed.' : null,
        );
      }
    } else if (event is GoogleSignInAuthenticationEventSignOut) {
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
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('google_auth_skipped', true);
    state = const GoogleAuthState(status: AuthStatus.skipped);
  }
}

final googleAuthControllerProvider =
    NotifierProvider.autoDispose<GoogleAuthController, GoogleAuthState>(
      () => GoogleAuthController(),
    );
