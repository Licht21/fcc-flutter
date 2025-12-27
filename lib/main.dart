// dependencies
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

// views
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
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        )
      ),
      home: const HomePage(),
      routes: {
        "/login":(BuildContext context) => const LoginView(),
        "/register":(BuildContext context) => const RegisterView(),
        "/notes":(BuildContext context) => const NotesView()
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
                return NotesView();
              } else if(user != null && user.emailVerified == false){
                return VerifyEmailView();
              } else {
                return LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
        }
    );
  }
}

enum MenuAction {
  logout,
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Your Notes"),
          actions: [
            PopupMenuButton<MenuAction>(
                onSelected: (value) async {
                  switch(value) {
                    case MenuAction.logout:
                      final shouldLogout = await showLogOutDialog(context);
                      if(shouldLogout) {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            "/login",
                            (_) => false);
                      }
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Text("Logout")
                    )
                  ];
                }
              )
          ],
        ),
        body: const Text("Hello World"),
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context,false);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context,true);
                },
                child: const Text("Logout"))
          ],
        );
      }
    ).then((value) => value ?? false);
}
