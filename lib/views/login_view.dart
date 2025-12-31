import 'package:flutter/material.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
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
                  await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );
                  if (!context.mounted) return;
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
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
                } on InvalidCredentialAuthException catch (_) {
                  showErrorDialog(context, "Invalid Credential");
                } on UserDisabledAuthException catch (_) {
                  showErrorDialog(context, "User Disabled");
                } on TooManyRequestAuthException catch (_) {
                  showErrorDialog(context, "Too Many Request");
                } on InvalidEmailAuthException catch (_) {
                  showErrorDialog(context, "Invalid Email Format");
                } on NetworkRequestFailedAuthException catch (_) {
                  showErrorDialog(
                    context,
                    "Network Error, Please Check Your Connection",
                  );
                } on GenericAuthException catch (_) {
                  showErrorDialog(context, "Authentication Error");
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
