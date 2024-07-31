import 'package:flutter/material.dart';
import 'package:food_task/google_auth.dart';
import 'package:food_task/screens/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ValueNotifier userCredential = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Food',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              userCredential.value = await GoogleAuth().signInWithGoogle();
              if (userCredential.value != null) {
                print(userCredential.value.user!.email);
                Navigator.of(context).pushReplacementNamed(HomePage.routeName);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: const Text(
                'Google..',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )),
      ),
    );
  }
}
