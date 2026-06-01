import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    final double screenWidth = MediaQuery.of(context).size.width;

    // Sleek border radius scaling to match inner items
    final double borderRadiusValue = screenWidth < 340
        ? 32.0
        : (screenWidth > 400 ? 48.0 : 44.0);
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkBackground.withValues(alpha: 0.90),
            blurRadius: 16.0,
            spreadRadius: 2.0,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: AppTheme.darkBackground.withValues(alpha: 0.70),
            blurRadius: 32.0,
            spreadRadius: 6.0,
            offset: const Offset(0, 0),
          ),
        ],
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
    ).animate().slideY(begin: 1.5, end: 0, curve: Curves.easeOutBack);
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
    final double screenWidth = MediaQuery.of(context).size.width;

    // Dynamic sleek padding that responds to screen width to prevent overflow
    // under high display scaling / small screens, while providing a substantial
    // feel on larger screens.
    final double paddingValue = screenWidth < 340
        ? 12.0
        : (screenWidth > 400 ? 18.0 : 16.0);

    final double marginValue = screenWidth < 340
        ? 3.0
        : (screenWidth > 400 ? 5.0 : 4.0);

    final double iconSize = screenWidth < 340
        ? 22.0
        : (screenWidth > 400 ? 26.0 : 24.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(paddingValue),
        margin: index == 0 || index == 3
            ? EdgeInsets.all(marginValue)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.darkBackground : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Iconify(
          isSelected ? _activeIcons[index] : _inactiveIcons[index],
          color: isSelected ? AppTheme.tertiaryLime : AppTheme.darkBackground,
          size: iconSize,
        ),
      ),
    );
  }
}
