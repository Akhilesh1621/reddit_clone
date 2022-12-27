import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utlis.dart';

import 'package:reddit_clone/features/auth/repository/auth_repository.dart';

//contoller is used to communicate the repostiory and screen that is done by controller
final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
  ),
);

class AuthController {
  final AuthRepository _authRepository;
  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  void signInWithGoogle(BuildContext context) async {
    final user = await _authRepository.signInWithGoogle();
    user.fold((l) => showSNackBar(context, l.message),
        (r) => showSNackBar(context, 'Login success'));
  }
}
