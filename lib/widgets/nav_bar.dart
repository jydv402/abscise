import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavBar extends StatelessWidget {
  /// The navigation shell provided by GoRouter's StatefulShellRoute
  final StatefulNavigationShell navigationShell;

  const CustomNavBar({super.key, required this.navigationShell});

  /// Helper method to safely switch branches when an item is tapped
  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .fromLTRB(8, 24, 8, 24),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [BoxShadow(color: Colors.white54, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.photo_library,
            label: 'Local',
            isSelected: navigationShell.currentIndex == 0,
            onTap: () => _onTabSelected(0),
          ),
          _NavBarItem(
            icon: Icons.cloud,
            label: 'Cloud',
            isSelected: navigationShell.currentIndex == 1,
            onTap: () => _onTabSelected(1),
          ),
          _NavBarItem(
            icon: Icons.delete,
            label: 'Bin',
            isSelected: navigationShell.currentIndex == 2,
            onTap: () => _onTabSelected(2),
          ),
          _NavBarItem(
            icon: Icons.settings,
            label: 'Stats',
            isSelected: navigationShell.currentIndex == 3,
            onTap: () => _onTabSelected(3),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, color: isSelected ? Colors.blue : Colors.grey)],
      ),
    );
  }
}
