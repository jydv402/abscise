import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../core/themes/app_theme.dart';

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
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple,
        border: Border.all(color: AppTheme.darkBackground, width: 3),
        borderRadius: BorderRadius.circular(56),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _NavBarItem(
            index: 0,
            isSelected: navigationShell.currentIndex == 0,
            onTap: () => _onTabSelected(0),
          ),
          _NavBarItem(
            index: 1,
            isSelected: navigationShell.currentIndex == 1,
            onTap: () => _onTabSelected(1),
          ),
          _NavBarItem(
            index: 2,
            isSelected: navigationShell.currentIndex == 2,
            onTap: () => _onTabSelected(2),
          ),
          _NavBarItem(
            index: 3,
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
    required this.index,
    required this.isSelected,
    required this.onTap,
  });
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  static const List<String> _activeIcons = [
    Ph.file_image_duotone,
    Ph.google_photos_logo_duotone,
    Ph.trash_duotone,
    Ph.graph_duotone,
  ];

  static const List<String> _inactiveIcons = [
    Ph.file_image_bold,
    Ph.google_photos_logo_bold,
    Ph.trash_bold,
    Ph.graph_bold,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: .all(24),
        margin: index == 0 || index == 3 ? .all(4) : .zero,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.darkBackground : Colors.transparent,
          shape: .circle,
        ),
        child: Iconify(
          isSelected ? _activeIcons[index] : _inactiveIcons[index],
          color: isSelected ? AppTheme.tertiaryLime : AppTheme.darkBackground,
        ),
      ),
    );
  }
}
