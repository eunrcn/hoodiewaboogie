import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';
import 'package:hoodie_w_a_boogie/home_page.dart';
import 'package:hoodie_w_a_boogie/utils.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  // ignore: empty_constructor_bodies
  @override
  State<SignUpWidget> createState() {
    return _SignUpWidgetState();
  }
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cuisineController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cuisineController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const FlutterLogo(size: 120),
              const SizedBox(height: 20),
              const Text(
                'Hehe whats up!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Name'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (name) {
                  return name!.isEmpty ? 'Please enter your name' : null;
                },
              ),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) {
                  if (email != null && !EmailValidator.validate(email)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: cuisineController,
                textInputAction: TextInputAction.next,
                decoration:
                    const InputDecoration(labelText: 'Favorite Cuisine'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (cuisine) {
                  return cuisine!.isEmpty
                      ? 'Please enter your favorite cuisine'
                      : null;
                },
              ),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != null && value.length < 6) {
                    return 'Enter min. 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: signUp,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Sign Up!'),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  text: 'Already have an account? ',
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: 'Log In',
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final cuisine = cuisineController.text.trim();

      // Create user account with email and password
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userUid = userCredential.user!.uid;

      // Save additional user information to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('userProfile')
          .doc(userUid) // Use userUid as the document ID
          .set({
        'name': name,
        'cuisine': cuisine,
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
