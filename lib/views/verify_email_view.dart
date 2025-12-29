import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                final User? user = FirebaseAuth.instance.currentUser;
                await user?.reload();
                await user?.sendEmailVerification();
              },
              child: const Text("Send Email Verification"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/login",
                  (_) => false,
                );
              },
              child: const Text("To Login Page"),
            ),
          ],
        ),
      ),
    );
  }
}
