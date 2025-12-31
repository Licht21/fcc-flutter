// dependencies
import 'package:flutter/material.dart';
import 'package:mynotes/views/home_page_view.dart';

// views
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

import 'package:mynotes/constants/routes.dart';

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
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (BuildContext context) => const LoginView(),
        registerRoute: (BuildContext context) => const RegisterView(),
        notesRoute: (BuildContext context) => const NotesView(),
        verifyEmailRoute: (BuildContext context) => const VerifyEmailView(),
      },
    );
  }
}
