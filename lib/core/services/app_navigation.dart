import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/achievments/achievements_page.dart';
import '../../features/home/home_page.dart';
import '../../features/quests/quests_page.dart';

class AppNavigation {
  static final _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final _questsNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'quests');
  static final _acheivementsNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'acheivements');

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: QuestsRoute.path,
    routes: routes,
    observers: [RedirectToHomeObserver()],
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

/// This observer redirects the user to the home page if the app doesn't have any routes left in its stack.
class RedirectToHomeObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (previousRoute == null && route.settings.name != '/') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = route.navigator!.context;
        GoRouter.of(context).goNamed(QuestsRoute.name);
      });
    }
  }
}
