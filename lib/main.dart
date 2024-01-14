import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() async {
  final appInitializationProvider = await AppInit.init();
  runApp(ProviderScope(
    parent: appInitializationProvider,
    child: const App(),
  ));
}
