import 'package:bloc/bloc.dart';
import 'package:deathnote/services/auth/auth_provider.dart';
import 'package:deathnote/services/auth/bloc/auth_event.dart';
import 'package:deathnote/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProviderr provider) : super(const AuthStateUninitialized()) {
    //send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e));
      }
    });
    //initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(AuthStateLoggedOut(
          null,
          false,
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user: user));
      }
    });
    //log in
    on<AuthEventLogIn>((event, emit) async {
      emit(AuthStateLoggedOut(
        null,
        true,
      ));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(AuthStateLoggedOut(
            null,
            false,
          ));
          emit(const AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedOut(
            null,
            false,
          ));
          emit(AuthStateLoggedIn(user: user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          e,
          false,
        ));
      }
    });
    on<AuthEventLogOut>((event, emit) async {
      try {
        emit(const AuthStateUninitialized());
        await provider.logOut();
        emit(AuthStateLoggedOut(
          null,
          false,
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          e,
          false,
        ));
      }
    });
     on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
      ));
    });
  }
}
