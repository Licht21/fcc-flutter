import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Verify Email")),
        body: Column(
          children: [
            const Text("We've sent you email verification!. Check Your Email"),
            const Text("Send Again?"),
            TextButton(
              onPressed: () async {
                try {
                  await AuthService.firebase().sendEmailVerification();
                } on UserNotLoggedInAuthException catch (_) {
                  if (!context.mounted) return;
                  showErrorDialog(context, "Please Login First!");
                }
              },
              child: const Text("Send Email Verification"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await AuthService.firebase().logOut();
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/login",
                    (_) => false,
                  );
                } on UserNotLoggedInAuthException catch (_) {
                  showErrorDialog(context, "Please Login First!");
                }
              },
              child: const Text("To Login Page"),
            ),
          ],
        ),
      ),
    );
  }
}
