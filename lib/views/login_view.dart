import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                hintText: "Enter your email here",
              ),
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(
                hintText: "Enter your password here",
              ),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  if (!context.mounted) return;
                  final User? user = FirebaseAuth.instance.currentUser;
                  if (user?.emailVerified ?? false) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      notesRoute,
                      (_) => false,
                    );
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/verify",
                      (_) => false,
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == "invalid-credential") {
                    showErrorDialog(context, "Invalid Credential");
                  } else if (e.code == "user-disabled") {
                    showErrorDialog(context, "User Disabled");
                  } else if (e.code == "too-many-requests") {
                    showErrorDialog(context, "Too Many Request");
                  } else if (e.code == "invalid-email") {
                    showErrorDialog(context, "Invalid Email Format");
                  } else if (e.code == "network-request-failed") {
                    showErrorDialog(
                      context,
                      "Network Error, Please Check Your Connection",
                    );
                  } else {
                    showErrorDialog(context, "Error : ${e.code}");
                  }
                } catch (e) {
                  showErrorDialog(context, "Error : ${e.toString()}");
                }
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text("Not Registered Yet? Register Here!"),
            ),
          ],
        ),
      ),
    );
  }
}
