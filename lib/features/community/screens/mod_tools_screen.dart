import 'package:flutter/material.dart';

class ModToolsScreen extends StatelessWidget {
  const ModToolsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mods tool'),
      ),
      body: Column(children: [
        ListTile(
          leading: const Icon(Icons.add_moderator),
          title: const Text(
            'Add Moderator',
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text(
            'Eddting Community',
          ),
          onTap: () {},
        ),
      ]),
    );
  }
}
