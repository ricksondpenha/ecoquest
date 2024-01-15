import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLifecycleProvider = StateProvider<AppLifecycleState>((ref) {
  final binding = WidgetsBinding.instance;
  final listener = AppLifecycleListener(
    binding: binding,
    onStateChange: (state) => state != ref.controller.state
        ? ref.controller.state = state
        : debugPrint('AppLifecycleObserver: $state'),
  );

  ref.onDispose(() {
    listener.dispose();
  });
  return binding.lifecycleState ?? AppLifecycleState.resumed;
});
