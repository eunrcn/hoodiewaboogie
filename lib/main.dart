import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoodie_w_a_boogie/auth_page.dart';
import 'package:hoodie_w_a_boogie/map.dart';
import 'package:hoodie_w_a_boogie/utils.dart';
import 'package:hoodie_w_a_boogie/verify_email_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MainPage());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(context) => MaterialApp(
        scaffoldMessengerKey: messengerKey,
        navigatorKey: navigatorKey,
        home: Scaffold(
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return const VerifyEmailPage();
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong!'),
                );
              } else {
                return const AuthPage();
              }
            },
          ),
        ),
      );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('hoodie w a boogie'),
        ),
        body: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Signed In as',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email!,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  icon: const Icon(Icons.arrow_back, size: 32),
                  label: const Text(
                    'Sign Out!',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MapApp()),
            );
          },
          tooltip: 'Head to Maps!',
          child: const Icon(Icons.map),
        ),
      ),
    );
  }
}
