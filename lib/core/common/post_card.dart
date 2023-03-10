import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/comunity_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';

import 'package:reddit_clone/models/post_model.dart';

import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

// delete post
  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  // upvote post
  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  // downvote post
  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  // award post
  void awardPost(WidgetRef ref, String awards, BuildContext context) async {
    ref
        .read(postControllerProvider.notifier)
        .awardPost(post: post, awards: awards, context: context);
  }

  // navigating to profile
  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  // navigating to communityProfile
  void navigateToCommunityProfile(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

// navigating to comment screen
  void navigateToCommentPage(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ).copyWith(right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(post.communityProfilePic),
                                  radius: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            navigateToCommunityProfile(context),
                                        child: Text(
                                          '/r ${post.communityName}',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => navigateToUser(context),
                                        child: Text(
                                          '/u ${post.username}',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (post.uid == user.uid)
                              IconButton(
                                onPressed: () => deletePost(ref, context),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )
                          ],
                        ),
//displaying awards
                        if (post.awards.isNotEmpty) ...[
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 25,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: post.awards.length,
                              itemBuilder: (BuildContext context, int index) {
                                final awards = post.awards[index];
                                return Image.asset(
                                  Constants.awards[awards]!,
                                  height: 23,
                                );
                              },
                            ),
                          ),
                        ],

                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isTypeImage)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: double.infinity,
                            child: Image.network(
                              post.link!,
                              fit: BoxFit.cover,
                            ),
                          )
                        else if (isTypeText)
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text(
                                  post.description!,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          )
                        else if (isTypeLink)
                          SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: AnyLinkPreview(
                              displayDirection:
                                  UIDirection.uiDirectionHorizontal,
                              link: post.link!,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => upvotePost(ref),
                              icon: Icon(
                                Constants.up,
                                size: 30,
                                color: post.upvotes.contains(user.uid)
                                    ? Pallete.redColor
                                    : null,
                              ),
                            ),
                            Text(
                              post.upvotes.length - post.downvotes.length == 0
                                  ? 'Vote'
                                  : '${post.upvotes.length - post.downvotes.length} ',
                              style: const TextStyle(fontSize: 17.0),
                            ),
                            IconButton(
                              onPressed: () => downvotePost(ref),
                              icon: Icon(
                                Constants.down,
                                size: 30,
                                color: post.downvotes.contains(user.uid)
                                    ? Pallete.blueColor
                                    : null,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => navigateToCommentPage(context),
                              icon: const Icon(
                                Icons.comment,
                              ),
                            ),
                            Text(
                              post.commentCount == 0
                                  ? 'comment'
                                  : '${post.commentCount} ',
                              style: const TextStyle(fontSize: 17.0),
                            ),
                          ],
                        ),
                        ref
                            .watch(
                                getCommunityByNameProvider(post.communityName))
                            .when(
                              data: (data) {
                                if (data.mods.contains(user.uid)) {
                                  return IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.admin_panel_settings,
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                              error: (error, stackTrace) => ErrorText(
                                error: error.toString(),
                              ),
                              loading: () => const Loader(),
                            ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: user.awards.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final awards = user.awards[index];
                                        return GestureDetector(
                                          onTap: () =>
                                              awardPost(ref, awards, context),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              Constants.awards[awards]!,
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.card_giftcard_outlined,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }
}
