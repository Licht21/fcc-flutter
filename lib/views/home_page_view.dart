import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';
import 'login_view.dart';
import 'notes_view.dart';
import 'verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.done:
            final User? user = FirebaseAuth.instance.currentUser;
            if (user != null && user.emailVerified) {
              return NotesView();
            } else if (user != null && user.emailVerified == false) {
              return VerifyEmailView();
            } else {
              return LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
