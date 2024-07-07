import 'package:flutter/material.dart';
import 'package:deathnote/constants/routes.dart';
import 'package:deathnote/views/login_view.dart';
import 'package:deathnote/views/register_view.dart';
import 'package:deathnote/views/verify_email_view.dart';
import 'package:deathnote/views/notes/notes_view.dart';
import 'package:deathnote/views/notes/new_notes_view.dart';
import 'package:deathnote/services/auth/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Death Note',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        newNoteRoute: (context) => const NewNotesView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                
                return const VerifyEmailView();
              }
            } else {
              
              return const LoginView();
            }
          default:
            return const Center(child: Text('Error initializing app'));
        }
      },
    );
  }
}
