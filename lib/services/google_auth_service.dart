// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleAuthService {
//   final GoogleSignIn _authInstance = GoogleSignIn.instance;

//   static const List<String> _scopes = [
//     'https://www.googleapis.com/auth/photoslibrary.readonly',
//     'https://www.googleapis.com/auth/photoslibrary.sharing',
//   ];

//   /// Performs initialization of the Google Sign-In service.
//   Future<void> initialize({
//     required Function(GoogleSignInAuthenticationEvent) onEvent,
//     required Function(Object) onError,
//     String? clientId,
//     String? serverClientId,
//   }) async {
//     final String? defaultClientId = dotenv.env['GOOGLE_CLIENT_ID'];
//     final String? defaultServerClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];

//     final String? activeClientId = (clientId != null && clientId.isNotEmpty)
//         ? clientId
//         : (defaultClientId != null && defaultClientId.isNotEmpty
//               ? defaultClientId
//               : null);

//     final String? activeServerClientId =
//         (serverClientId != null && serverClientId.isNotEmpty)
//         ? serverClientId
//         : (defaultServerClientId != null && defaultServerClientId.isNotEmpty
//               ? defaultServerClientId
//               : null);

//     try {
//       await _authInstance.initialize(
//         clientId: activeClientId,
//         serverClientId: activeServerClientId,
//       );
//     } catch (e) {
//       if (activeServerClientId == null) {
//         // ignore: avoid_print
//         print(
//           'WARNING: [GoogleAuthService] Initialization failed or might fail because no serverClientId was provided. '
//           'Android Credential Manager requires a Web Client ID as the serverClientId. '
//           'Please ensure GOOGLE_SERVER_CLIENT_ID is defined in your .env file and loaded via dotenv.',
//         );
//       }
//       rethrow;
//     }

//     _authInstance.authenticationEvents.listen(onEvent).onError(onError);
//   }

//   /// Attempts silent sign-in with Google on app startup.
//   Future<void> backgroundAuth() async {
//     await _authInstance.attemptLightweightAuthentication();
//   }

//   /// Requests explicit permission to access Google Photos scopes from the user
//   Future<bool> requestPhotosScopes(GoogleSignInAccount user) async {
//     try {
//       // ignore: unused_local_variable
//       final GoogleSignInClientAuthorization auth = await user
//           .authorizationClient
//           .authorizeScopes(_scopes);
//       // If authorization completes, the token is successfully cached natively
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   /// Checks if the user has authorized the explicit Google Photos scopes
//   Future<bool> checkScopeAuthorization(GoogleSignInAccount user) async {
//     final GoogleSignInClientAuthorization? auth = await user.authorizationClient
//         .authorizationForScopes(_scopes);
//     return auth != null;
//   }

//   /// Triggers the native platform authentication web dialog overlay
//   Future<void> newAuth() async {
//     if (_authInstance.supportsAuthenticate()) {
//       await _authInstance.authenticate();
//     } else {
//       throw UnsupportedError(
//         'Authentication is not supported on this device platform.',
//       );
//     }
//   }

//   /// Completely disconnects the account and revokes access privileges
//   Future<void> logOut() async {
//     await _authInstance.disconnect();
//   }
// }
