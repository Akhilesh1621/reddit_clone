import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/sign_in_button.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/comunity_controller.dart';
import 'package:reddit_clone/models/community_model.dart';

import 'package:routemaster/routemaster.dart';

import '../../../router.dart';

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({Key? key}) : super(key: key);

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunityProfile(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          isGuest
              ? const SignInButton(
                  isFromLogin: false,
                )
              : ListTile(
                  title: const Text('Create a community'),
                  leading: const Icon(Icons.add),
                  onTap: () => navigateToCreateCommunity(context),
                ),
          if (!isGuest)
            ref.watch(userCommunitiesProvider).when(
                data: (Community) => Expanded(
                      child: ListView.builder(
                        itemCount: Community.length,
                        itemBuilder: (BuildContext context, int index) {
                          final community = Community[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                            title: Text('r/${community.name}'),
                            onTap: () {
                              navigateToCommunityProfile(context, community);
                            },
                          );
                        },
                      ),
                    ),
                error: (error, stacktrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader())
        ],
      )),
    );
  }
}
