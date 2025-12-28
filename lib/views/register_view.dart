import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        appBar: AppBar(title: Text("Register")),
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
                  final UserCredential user = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                  if (!context.mounted) return;
                  devtools.log(user.toString());
                } on FirebaseAuthException catch (e) {
                  if (e.code == "email-already-in-use") {
                    showErrorDialog(context, "Email Has Been Used");
                  } else if (e.code == "invalid-email") {
                    showErrorDialog(context, "Invalid Email Format");
                  } else if (e.code == "weak-password") {
                    showErrorDialog(context, "Weak Password");
                  } else if (e.code == "too-many-request") {
                    showErrorDialog(context, "Too Many Request");
                  } else if (e.code == "network-request-failed") {
                    showErrorDialog(
                      context,
                      "Network Error, Please Check Your Connection!",
                    );
                  } else {
                    showErrorDialog(context, "Error : ${e.code}");
                  }
                } catch (e) {
                  showErrorDialog(context, "Error : ${e.toString()}");
                }
              },
              child: const Text("Register"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text("Already Register? Login Here!"),
            ),
          ],
        ),
      ),
    );
  }
}
