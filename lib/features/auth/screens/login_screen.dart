import 'package:flutter/material.dart';

import '../../../core/common/sign_in_button.dart';
import '../../../core/constants/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 80.0),
          child: Center(
            child: Image.asset(
              Constants.logoPath,
              height: 40.0,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30.0,
          ),
          const Text(
            '"Dive Into Anything"',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              Constants.loginEmotePath,
              height: 400.0,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const SignInButton(),
        ],
      ),
    );
  }
}
