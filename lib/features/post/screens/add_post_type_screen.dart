import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/features/community/controller/comunity_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';

import '../../../core/common/loader.dart';
import '../../../core/utlis.dart';
import '../../../home/user_profile/controller/user_profile_controller.dart';
import '../../../models/community_model.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;

  const AddPostTypeScreen({required this.type, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkContoller = TextEditingController();
  File? bannerFile;
  List<Community> communties = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  // connecting the controller to add screen

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).sharedImagePost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communties[0],
          file: bannerFile);
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).sharedTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communties[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkContoller.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).sharedlinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communties[0],
            link: linkContoller.text.trim(),
          );
    } else {
      showSNackBar(context, 'Please enter all the fields bro');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(postControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text('share'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Enter Ttile here',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18.0),
                  ),
                  maxLength: 30,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                if (isTypeImage)
                  GestureDetector(
                    onTap: selectBannerImage,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10.0),
                      color: currentTheme.textTheme.bodyText2!.color!,
                      dashPattern: const <double>[10, 4],
                      strokeCap: StrokeCap.round,
                      child: Container(
                          width: double.infinity,
                          height: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: isLoading
                              ? const Loader()
                              : bannerFile != null
                                  ? Image.file(
                                      bannerFile!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 40.0,
                                      ),
                                    )),
                    ),
                  ),
                if (isTypeText)
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter description here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18.0),
                    ),
                    maxLines: 5,
                    maxLength: 160,
                  ),
                if (isTypeLink)
                  TextField(
                    controller: linkContoller,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter link here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18.0),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('Select Community'),
                ),
                ref.watch(userCommunitiesProvider).when(
                      data: (data) {
                        communties = data;

                        if (data.isEmpty) {
                          return const SizedBox();
                        }
                        return DropdownButton(
                          value: selectedCommunity ?? data[0],
                          items: data
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e.name)))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedCommunity = val as Community?;
                            });
                          },
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                      ),
                      loading: () => const Loader(),
                    )
              ]),
            ),
    );
  }
}
