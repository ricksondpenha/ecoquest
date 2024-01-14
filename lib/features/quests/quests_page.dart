import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return const Placeholder(
      child: Text('Quests Page'),
    );
  }
}
