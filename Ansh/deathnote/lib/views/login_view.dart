import 'package:deathnote/services/auth/auth_exceptions.dart';
import 'package:deathnote/services/auth/bloc/auth_bloc.dart';
import 'package:deathnote/services/auth/bloc/auth_event.dart';
import 'package:deathnote/services/auth/bloc/auth_state.dart';
import 'package:deathnote/utilities/dialog/error_dialog.dart';
import 'package:deathnote/utilities/dialog/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

  @override
  void initState() {
    
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;
          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialogHandle = showLoadingDialog(
              context: context,
              text: 'Loading...',
            );
          }
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not Found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  
                  decoration: const InputDecoration(
                     hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Enter your email here',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                     hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Enter your password here',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    context.read<AuthBloc>().add(AuthEventLogIn(
                          email: email,
                          password: password,
                        ));
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventShouldRegister(),
                        );
                  },
                  child: const Text(
                    'Not registered yet? Register Here',
                  ),
                )
              ],
            ),
          )),
    );
  }
}
