import 'package:deathnote/services/auth/auth_exceptions.dart';
import 'package:deathnote/services/auth/bloc/auth_bloc.dart';
import 'package:deathnote/services/auth/bloc/auth_event.dart';
import 'package:deathnote/services/auth/bloc/auth_state.dart';
import 'package:deathnote/utilities/dialog/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyInUsedAuthException) {
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to Register');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid Email');
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Register'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
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
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
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
                    context.read<AuthBloc>().add(AuthEventRegister(
                          email: email,
                          password: password,
                        ));
                  },
                  child: const Text('Register'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  },
                  child: const Text('Already registered? Login Here'),
                )
              ],
            ),
          )),
    );
  }
}
