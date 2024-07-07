import 'package:deathnote/constants/routes.dart';
import 'package:deathnote/services/auth/auth_exceptions.dart';
import 'package:deathnote/services/auth/auth_service.dart';
import 'package:deathnote/utilities/dialog/error_dialog.dart';
import 'package:flutter/material.dart';
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
    return Scaffold( 
      appBar: AppBar(title: const Text('Register'),),
    
    body : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration:const InputDecoration(
                        hintText: 'Enter your email here',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'Enter your password here',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                           await AuthService.firebase().createUser(email: email, password: password);
                           Navigator.of(context).pushNamed(
                            verifyEmailRoute,  
                            );
                            AuthService.firebase().sendEmailVerification();
                        }
                        on WeakPasswordAuthException{
                          await showErrorDialog(context,'Marial-password bro');
                        } on EmailAlreadyInUsedAuthException{
                          await showErrorDialog(context,'email-already-in-use bro');
                        } on InvalidEmailAuthException{
                          await showErrorDialog(context,'invalid-email bro');
                        } on GenericAuthException{
                            await showErrorDialog(context,'Failed to Register');
                        }
                      },
                      child: const Text('Register'),
                    ),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route)=>false,);
                    },
                    child: const Text('Already registered? Login Here'),)
                  ],
                ),
              )
              );
  }
}
