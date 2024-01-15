import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/app_lifecycle.dart';


class QuestsRoute extends StatelessWidget {
  const QuestsRoute({super.key});

  static const String name = 'quests';
  static const String path = '/quests';

  static navigate(BuildContext context) => context.goNamed(name);

  @override
  Widget build(BuildContext context) {
    return const QuestsPage();
  }
}

class QuestsPage extends StatelessWidget {
  const QuestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Consumer(
        builder: (context, ref, child) {
          return Text(
              'Quests Page lifecycle state: ${ref.watch(appLifecycleProvider).name}');
        },
      ),
    );
  }
}
