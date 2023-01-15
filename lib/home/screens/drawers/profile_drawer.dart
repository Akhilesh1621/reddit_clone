import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void navigateToUserProfile(BuildContext context, UserModel user) {
    Routemaster.of(context).push('/u/${user.uid}');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 70,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'u/${user.name}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Divider(),
            ListTile(
              title: const Text('M Profile'),
              leading: const Icon(Icons.people),
              onTap: () => navigateToUserProfile(context, user),
            ),
            ListTile(
              title: const Text('LOg Out'),
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              onTap: () => logout(ref),
            ),
            Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode ==
                  ThemeMode.dark,
              onChanged: (val) => toggleTheme(ref),
            ),
          ],
        ),
      ),
    );
  }
}
