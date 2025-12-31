import 'package:flutter/material.dart';

import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null && user.isEmailVerified) {
              return NotesView();
            } else if (user != null && user.isEmailVerified == false) {
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
