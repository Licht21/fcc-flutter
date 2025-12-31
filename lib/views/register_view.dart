import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
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
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  await AuthService.firebase().sendEmailVerification();
                  if (!context.mounted) return;
                  await showErrorDialog(context, "Success To Register Account");
                  devtools.log("Registered Account");
                  if (!context.mounted) return;
                  Navigator.pushNamed(context, "/verify");
                } on EmailAlreadyInUseAuthException catch (_) {
                  showErrorDialog(context, "Email Has Been Used");
                } on InvalidEmailAuthException catch (_) {
                  showErrorDialog(context, "Invalid Email Format");
                } on WeakPasswordAuthException catch (_) {
                  showErrorDialog(context, "Weak Password");
                } on TooManyRequestAuthException catch (_) {
                  showErrorDialog(context, "Too Many Request");
                } on NetworkRequestFailedAuthException catch (_) {
                  showErrorDialog(
                    context,
                    "Network Error, Please Check Your Connection!",
                  );
                } on UserNotLoggedInAuthException catch (_) {
                  showErrorDialog(context, "Please Login First!");
                } on GenericAuthException catch (_) {
                  showErrorDialog(context, "Authentication Error");
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
