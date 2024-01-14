import 'package:flutter/material.dart';

class NavItem {
  final String label;
  final Icon icon;
  final String route;

  const NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}

class BottomBar extends StatelessWidget {
  final List<NavItem> navItems;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const BottomBar(
      {super.key,
      required this.navItems,
      required this.selectedIndex,
      required this.onDestinationSelected})
      : assert(selectedIndex >= 0 && selectedIndex < navItems.length);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onDestinationSelected,
      items: navItems
          .map((e) => BottomNavigationBarItem(icon: e.icon, label: e.label))
          .toList(),
    );
  }
}
