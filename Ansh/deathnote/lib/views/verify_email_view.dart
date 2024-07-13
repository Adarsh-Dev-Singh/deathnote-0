// import 'package:deathnote/main.dart';
import 'package:deathnote/services/auth/auth_service.dart';
import 'package:deathnote/services/auth/auth_user.dart';
import 'package:deathnote/services/auth/bloc/auth_bloc.dart';
import 'package:deathnote/services/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  void initState() {
    super.initState();
    checkEmailVerified(context);
  }

  Future<void> checkEmailVerified(BuildContext context) async {
    AuthUser? user = AuthService.firebase().currentUser;
    while (user != null && !user.isEmailVerified) {
      await Future.delayed(const Duration(seconds: 3));
      await user.reload();
      user = AuthService.firebase().currentUser;
      if (user?.isEmailVerified ?? false) {
        context.read<AuthBloc>().add(
                       const AuthEventInitialize(),
                      );
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "We've already sent you a verification email. Click on it to verify your account.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Haven't received the verification email yet? Press the button below.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                        const AuthEventSendEmailVerification(),
                      );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                ),
                child: const Text(
                  'Send Email Verification',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                ),
                child: const Text(
                  'Restart',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
