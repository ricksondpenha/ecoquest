import 'package:ecoquest/features/achievments/achievements_page.dart';
import 'package:ecoquest/features/quests/quests_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_page.dart';

class AppNavigation {
  static final _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final _questsNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'quests');
  static final _acheivementsNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'acheivements');

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: QuestsRoute.path,
    routes: routes,
  );

  static final routes = <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomePage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _questsNavigatorKey,
          routes: [
            GoRoute(
              name: QuestsRoute.name,
              path: QuestsRoute.path,
              builder: (context, state) => const QuestsRoute(),
            )
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _acheivementsNavigatorKey,
          routes: [
            GoRoute(
              name: AchievementsRoute.name,
              path: AchievementsRoute.path,
              builder: (context, state) => const AchievementsRoute(),
            )
          ],
        ),
      ],
    ),
  ];
}
