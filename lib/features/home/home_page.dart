import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../achievments/achievements_page.dart';
import '../quests/quests_page.dart';
import 'widgets/bottom_bar.dart';
import 'widgets/shell_appbar.dart';

class HomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const HomePage({super.key, required this.navigationShell});

  static const String name = 'home';
  static const String path = QuestsRoute.path;

  void navigate(int selectedIndex) {
    navigationShell.goBranch(
      selectedIndex,
      initialLocation: selectedIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShellAppBar(title: 'EcoQuest'),
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
