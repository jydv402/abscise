import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus { checking, authenticated, unauthenticated, skipped }

class GoogleAuthState {
  final AuthStatus status;
  final String? errorMsg;
  final GoogleSignInAccount? user;

  const GoogleAuthState({
    this.status = AuthStatus.checking,
    this.errorMsg,
    this.user,
  });

  GoogleAuthState copyWith({
    AuthStatus? status,
    String? errorMsg,
    GoogleSignInAccount? user,
  }) {
    return GoogleAuthState(
      status: status ?? this.status,
      errorMsg: errorMsg,
      user: user ?? this.user,
    );
  }
}
