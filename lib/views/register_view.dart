import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Column(
        children: [
          TextField(
              controller: _email,
              decoration: const InputDecoration(
                  hintText: "Enter your email here"
              ),
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(
                hintText: "Enter your password here"
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
                  final UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                  print(user);
                } on FirebaseAuthException catch(e) {
                  if(e.code == "email-already-in-use") {
                    print("Email Has Been Used");
                  } else if(e.code == "invalid-email"){
                    print("Email Invalid");
                  } else if(e.code == "weak-password") {
                    print("Weak Password");
                  }
                }
              },
              child: const Text("Register")
          ),
          TextButton(onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context,
                "/login",
                (route) => false);
          },
              child: const Text("Already Register? Login Here!"))
        ],
      ),
    );
  }
}