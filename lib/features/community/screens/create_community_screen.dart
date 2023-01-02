import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/comunity_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController;
  }

  void createCommunity() {
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(communityNameController.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Community'),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Community name',
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: communityNameController,
                  decoration: const InputDecoration(
                    hintText: 'r/Community',
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18.0),
                  ),
                  maxLength: 21,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: createCommunity,
                  child: const Text(
                    'Create community',
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
              ]),
            ),
    );
  }
}
