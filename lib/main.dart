import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        "/login":(BuildContext context) => const LoginView(),
        "/register":(BuildContext context) => const RegisterView()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform
        ),
        builder: (context, asyncSnapshot) {
          switch(asyncSnapshot.connectionState) {
            case ConnectionState.done:
              final User? user = FirebaseAuth.instance.currentUser;
              print(user);
              if(user != null && user.emailVerified) {
                return VerifyEmailView();
              } else {
                return LoginView();
              }

          // final User? user = FirebaseAuth.instance.currentUser;
          // final uid = user?.uid;
          // print("$user : $uid");
          // if(user?.emailVerified ?? false) {
          //   return const Text("Verified User");
          // } else {
          //   return const VerifyEmailView();
          // }
            default:
              return const CircularProgressIndicator();
          }
        }
    );
  }
}
