import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavBar extends StatelessWidget {
  /// The navigation shell provided by GoRouter's StatefulShellRoute
  final StatefulNavigationShell navigationShell;

  const CustomNavBar({
    super.key,
    required this.navigationShell,
  });

  /// Helper method to safely switch branches when an item is tapped
  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      // A common production practice: if the user taps the active tab again,
      // it resets that tab's navigation stack back to its root screen.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // We will build the visual floating action button layout right here next.
    // For now, we will return a minimal structural placeholder.
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      fixedColor: Colors.white,
      useLegacyColorScheme: false,
      unselectedItemColor: Colors.red,
      currentIndex: navigationShell.currentIndex,
      onTap: _onTabSelected,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.phone_android), label: 'Local'),
        BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Cloud'),
        BottomNavigationBarItem(icon: Icon(Icons.delete), label: 'Bin'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
      ],
    );
  }
}
