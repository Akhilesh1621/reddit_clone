import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/home/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_clone/home/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/provider/storeage_repository_provider.dart';
import '../../../core/utlis.dart';
import '../../../models/post_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
      userProfileRepository: userProfileRepository,
      ref: ref,
      storageRepository: storageRepository);
});

// stream provider for getting user post to display in profile screen

final getUserPostProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(userProfileControllerProvider.notifier).getUserPost(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRespository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController({
    required UserProfileRespository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

//edit community image adding in storage

  void EditProfileScreen({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required String name,
  }) async {
// image selected from gallery will be stored as 'communities/profile/filename'
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'user/profile',
        id: user.uid,
        file: profileFile,
      );
      res.fold((l) => showSNackBar(context, l.message), (r) {
        user = user.copyWith(profilePic: r);
        showSNackBar(context, 'profile updated');
      });
    }

// image selected from gallery will be stored as 'communities/banner/filename'
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'user/banner',
        id: user.uid,
        file: bannerFile,
      );

      res.fold(
        (l) => showSNackBar(context, l.message),
        (r) {
          user = user.copyWith(banner: r);
          showSNackBar(context, 'Banner updated');
        },
      );
    }

    user = user.copyWith(name: name);
    final res = await _userProfileRepository.editProfile(user);
    state = false;
    res.fold((l) => showSNackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }

//displayin post in user screen and create stream provider
  Stream<List<Post>> getUserPost(String uid) {
    return _userProfileRepository.getUserPost(uid);
  }
}
