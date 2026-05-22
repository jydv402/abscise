import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _authInstance = GoogleSignIn.instance;

  static const List<String> _scopes = [
    'https://www.googleapis.com/auth/photoslibrary.readonly',
    'https://www.googleapis.com/auth/photoslibrary.sharing',
  ];

  /// Performs initialization of the Google Sign-In service.
  Future<void> initialize({
    required Function(GoogleSignInAuthenticationEvent) onEvent,
    required Function(Object) onError,
  }) async {
    await _authInstance.initialize();

    _authInstance.authenticationEvents.listen(onEvent).onError(onError);
  }

  /// Attempts silent sign-in with Google on app startup.
  Future<void> backgroundAuth() async {
    await _authInstance.attemptLightweightAuthentication();
  }

  /// Requests explicit permission to access Google Photos scopes from the user
  Future<bool> requestPhotosScopes(GoogleSignInAccount user) async {
    try {
      // ignore: unused_local_variable
      final GoogleSignInClientAuthorization auth = await user
          .authorizationClient
          .authorizeScopes(_scopes);
      // If authorization completes, the token is successfully cached natively
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Checks if the user has authorized the explicit Google Photos scopes
  Future<bool> checkScopeAuthorization(GoogleSignInAccount user) async {
    final GoogleSignInClientAuthorization? auth = await user.authorizationClient
        .authorizationForScopes(_scopes);
    return auth != null;
  }

  /// Triggers the native platform authentication web dialog overlay
  Future<void> newAuth() async {
    if (_authInstance.supportsAuthenticate()) {
      await _authInstance.authenticate();
    } else {
      throw UnsupportedError(
        'Authentication is not supported on this device platform.',
      );
    }
  }

  /// Completely disconnects the account and revokes access privileges
  Future<void> logOut() async {
    await _authInstance.disconnect();
  }
}
