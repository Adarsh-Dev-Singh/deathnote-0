import 'package:deathnote/constants/routes.dart';
import 'package:deathnote/utilities/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

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
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          devtools.log(userCredential.toString());
                        } on FirebaseAuthException catch (e) {
                        if(e.code == 'weak-password'){
                         await showErrorDialog(context,'Marial-password bro');
                        }else if(e.code == 'email-already-in-use'){
                          await showErrorDialog(context,'email-already-in-use bro');
                        
                        }else if(e.code == 'invalid-email'){
                          await showErrorDialog(context,'invalid-email bro');
                        } else {
                          await showErrorDialog(context,e.code);
                        }
                        }catch(e){
                          await showErrorDialog(
                            context,
                            e.toString(),
                            );
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
