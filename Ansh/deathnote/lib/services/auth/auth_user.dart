import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;

class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  final User _user;

  AuthUser(this._user)
      : id = _user.uid,
        email = _user.email!,
        isEmailVerified = _user.emailVerified;

  factory AuthUser.fromFirebase(User user) => AuthUser(user);

  Future<AuthUser> reload() async {
    await _user.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;
    if (refreshedUser == null) {
      throw Exception("User is no longer authenticated");
    }
    return AuthUser.fromFirebase(refreshedUser);
  }
}
