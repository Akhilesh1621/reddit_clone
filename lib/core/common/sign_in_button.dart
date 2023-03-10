import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';

//convert this staless width to consumer widget
class SignInButton extends ConsumerWidget {
  const SignInButton({Key? key}) : super(key: key);

  //creating function to bind with ui screen
  void signWithGooogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signWithGooogle(context, ref),
        icon: Image.asset(
          Constants.googlePath,
          width: 35.0,
        ),
        label: const Text(
          'Continue with Google',
          style: TextStyle(fontSize: 18.0),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Pallete.greyColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0))),
      ),
    );
  }
}
