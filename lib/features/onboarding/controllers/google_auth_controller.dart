import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../logic/google_auth_service.dart';
import '../state/google_auth_state.dart';

class GoogleAuthController extends Notifier<GoogleAuthState> {
  late final GoogleAuthService _authService;

  @override
  GoogleAuthState build() {
    _authService = GoogleAuthService();

    // Start listening to the native stream immediately
    _authService.initialize(
      onEvent: _handleAuthEvent,
      onError: _handleAuthError,
    );

    // Trigger the silent/lightweight check on startup
    _checkSilentAuth();

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
          errorMsg: 'Photos access authorization needed.',
        );
      }
    } else if (event is GoogleSignInAuthenticationEventSignOut) {
      state = const GoogleAuthState(status: AuthStatus.unauthenticated);
    }
  }

  void _handleAuthError(Object error) {
    state = GoogleAuthState(
      status: AuthStatus.unauthenticated,
      errorMsg: 'Authentication error: $error',
    );
  }

  Future<void> login() async {
    state = state.copyWith(status: AuthStatus.checking);
    try {
      await _authService.newAuth();
    } catch (e) {
      state = GoogleAuthState(
        status: AuthStatus.unauthenticated,
        errorMsg: e.toString(),
      );
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

  void skip() {
    state = const GoogleAuthState(status: AuthStatus.skipped);
  }
}

final googleAuthControllerProvider =
    NotifierProvider.autoDispose<GoogleAuthController, GoogleAuthState>(
      () => GoogleAuthController(),
    );
