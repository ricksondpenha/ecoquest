import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {
  static final _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: routes,
  );

  static final routes = <RouteBase>[
    StatefulShellRoute.indexedStack(
      branches: const [],
      parentNavigatorKey: _shellNavigatorKey,
    ),
  ];
}
