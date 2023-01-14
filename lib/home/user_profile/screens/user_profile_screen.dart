import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: ref.watch(getUserDataProvider(uid)).when(
              data: (user) => NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScroller) {
                  return [
                    SliverAppBar(
                      snap: true,
                      floating: true,
                      expandedHeight: 250.0,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              user.banner,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(20).copyWith(
                              bottom: 70,
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePic),
                              radius: 45,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(20),
                            child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0)),
                              onPressed: () {},
                              child: const Text('Edit Profile'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(
                        16.0,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'u/${user.name}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text('${user.karma} Karma'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: const Text(
                  'Displaying Post',
                ),
              ),
              error: (error, stacktrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            ),
      ),
    );
  }
}
