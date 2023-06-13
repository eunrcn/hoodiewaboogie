import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hoodie_w_a_boogie/main.dart';
import 'package:hoodie_w_a_boogie/utils.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(context) {
    return isEmailVerified
        ? const Home()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Verify Email'),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'A verification email has been sent.',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: sendVerificationEmail,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      icon: const Icon(Icons.email, size: 32),
                      label: const Text(
                        'Resent Email',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50)),
                      onPressed: FirebaseAuth.instance.signOut,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 24),
                      ),
                    )
                  ],
                )),
          );
  }
}
