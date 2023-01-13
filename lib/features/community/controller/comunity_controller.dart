import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/faliure.dart';
import 'package:reddit_clone/core/provider/storeage_repository_provider.dart';
import 'package:reddit_clone/core/utlis.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repsitory.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final communityControllerProvider =
    StateNotifierProvider<ComunnityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ComunnityController(
      communityRepository: communityRepository,
      ref: ref,
      storageRepository: storageRepository);
});

//profile UI screen
final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

//search

final searchCommunityProvider = StreamProvider.family((ref, String name) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(name);
});

class ComunnityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  ComunnityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSNackBar(context, l.message), (r) {
      showSNackBar(context, 'Community Created Succesfully');
      Routemaster.of(context).pop();
    });
  }

  //creating function for joining & leaving  community

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;

    if (community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }
    res.fold(
      (l) => showSNackBar(context, l.message),
      (r) {
        if (community.members.contains(user.uid)) {
          showSNackBar(context, 'Community left successfully!');
        } else {
          showSNackBar(context, 'Community joined successfully!');
        }
      },
    );
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

//edit community image adding in storage

  void editCommunity(
      {required File? profileFile,
      required File? bannerFile,
      required BuildContext context,
      required Community community}) async {
// image selected from gallery will be stored as 'communities/profile/filename'
    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );
      res.fold((l) => showSNackBar(context, l.message), (r) {
        community = community.copyWith(avatar: r);
        showSNackBar(context, 'profile updated');
      });
    }
// image selected from gallery will be stored as 'communities/banner/filename'
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );

      res.fold(
        (l) => showSNackBar(context, l.message),
        (r) {
          community = community.copyWith(banner: r);
          showSNackBar(context, 'Banner updated');
        },
      );
    }
    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold(
      (l) => showSNackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }
}
