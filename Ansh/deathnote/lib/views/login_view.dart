import 'package:deathnote/constants/routes.dart';
import 'package:deathnote/utilities/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text('Login'),),
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
                      decoration: const InputDecoration(
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
                         await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                       Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (route) => false,);
                        } on FirebaseAuthException catch(e){
                        if(e.code == 'invalid-credential'){
                            await showErrorDialog(context,'Invalid-credential Bro');
                        } else if(e.code == 'wrong-password'){
                          await showErrorDialog(context,'wrong password');
                        } else{
                          await showErrorDialog(context,e.code);
                        }
                          
                        }catch(e){
                          await showErrorDialog(
                            context,
                            e.toString(),
                            );
                        }
                        
                         
                      },
                      child: const Text('Login'),
                    ),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route)=>false,);
                    },
                    child: const Text('Not registered yet? Register Here'),)
                  ],
                ),
    )
              );
  }
}
