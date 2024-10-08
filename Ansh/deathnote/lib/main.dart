import 'package:deathnote/services/auth/bloc/auth_bloc.dart';
import 'package:deathnote/services/auth/bloc/auth_event.dart';
import 'package:deathnote/services/auth/bloc/auth_state.dart';
import 'package:deathnote/services/auth/firebase_auth_provider.dart';
import 'package:deathnote/views/cart_view.dart';
import 'package:deathnote/views/main_page.dart';
import 'package:flutter/material.dart';
import 'package:deathnote/constants/routes.dart';
import 'package:deathnote/views/login_view.dart';
import 'package:deathnote/views/register_view.dart';
import 'package:deathnote/views/verify_email_view.dart';
// import 'package:deathnote/views/notes/notes_view.dart';
import 'package:deathnote/views/notes/create_update_notes_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Death Note',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(backgroundColor: Colors.black ),
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        cartRoute: (context) => const CartView(),
        homeRoute:(context)=> const HomePage(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const MainPage();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
