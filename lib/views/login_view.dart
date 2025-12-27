import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/main.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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
                  final UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }));
                } on FirebaseAuthException catch (e){
                  if(e.code == "invalid-credential"){
                    print("Wrong Credential");
                  }
                }
                // final UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                // print(user);
              },
              child: const Text("Login")
          ),
          TextButton(onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context,
                "/register",
                (route) => false
            );
          },
              child: const Text("Not Registered Yet? Register Here!"))
        ],
      ),
    );
  }
}
