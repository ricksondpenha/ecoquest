import 'package:ecoquest/features/home/widgets/bottom_bar.dart';
import 'package:ecoquest/features/home/widgets/shell_appbar.dart';
import 'package:ecoquest/features/quests/quests_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../achievments/achievements_page.dart';

class HomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const HomePage({super.key, required this.navigationShell});

  static const String name = 'home';
  static const String path = QuestsRoute.path;

  void navigate(int selectedIndex) {
    navigationShell.goBranch(
      selectedIndex,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: selectedIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShellAppBar(title: 'title'),
      body: navigationShell,
      bottomNavigationBar: BottomBar(
        navItems: const [
          NavItem(
            label: 'Quests',
            icon: Icon(Icons.list),
            route: QuestsRoute.name,
          ),
          NavItem(
            label: 'Achievements',
            icon: Icon(Icons.emoji_events),
            route: AchievementsRoute.name,
          ),
        ],
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigate,
      ),
    );
  }
}
