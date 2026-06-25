import 'package:deathnote/services/auth/auth_provider.dart';
import 'package:deathnote/services/auth/auth_user.dart';
import 'package:deathnote/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProviderr{
  final AuthProviderr providerr;
  const AuthService(this.providerr);

  factory AuthService.firebase()=> AuthService(FirebaseAuthProvider());
  
  @override
  Future<AuthUser> createUser({required String email, required String password}) =>
   providerr.createUser(email: email, 
   password: password,
   );
  
  
  @override
  AuthUser? get currentUser => providerr.currentUser;
  
  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
    providerr.logIn(email: email, password: password);
  
  
  @override
  Future<void> logOut() =>
    providerr.logOut();
  
  
  @override
  Future<void> sendEmailVerification() =>
   providerr.sendEmailVerification();
   
     @override
     Future<void> initialize()=>
      providerr.initialize();
     
}