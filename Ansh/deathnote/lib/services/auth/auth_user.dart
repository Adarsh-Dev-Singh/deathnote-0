import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final User _user;
  final String? email;
  final bool isEmailVerified;

  AuthUser(this._user)
      : email = _user.email,
        isEmailVerified = _user.emailVerified;

  factory AuthUser.fromFirebase(User user) => AuthUser(user);

  Future<AuthUser> reload() async {
    await _user.reload();
    return AuthUser.fromFirebase(FirebaseAuth.instance.currentUser!);
  }
}
