import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/audio_controller.dart';

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  static const String name = 'settings';
  static const String path = '/settings';

  static navigate(BuildContext context) => context.goNamed(name);

  @override
  Widget build(BuildContext context) {
    return const SettingsPage();
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: const [
            ListTile(
              title: Text('Profile'),
              leading: Icon(Icons.person),
            ),
            ListTile(
              title: Text('Notifications'),
              leading: Icon(Icons.notifications),
            ),
            ListTile(
              title: Text('Privacy'),
              leading: Icon(Icons.privacy_tip),
            ),
            ListTile(
              title: Text('About'),
              leading: Icon(Icons.info),
            ),
            AudioSettings(),
          ],
        ));
  }
}

class AudioSettings extends StatelessWidget {
  const AudioSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            CheckboxListTile.adaptive(
              value: ref.watch(audioControllerProvider).musicOn,
              title: const Text('Music'),
              onChanged: (value) {},
            ),
            CheckboxListTile.adaptive(
              value: ref.watch(audioControllerProvider).musicOn,
              title: const Text('Sound Effects'),
              onChanged: (value) {},
            ),
          ],
        );
      },
    );
  }
}
