import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'nav_bar_item.dart';
import '../../themes/app_theme.dart';
import 'nav_bar_widget.dart';

class TabNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final double borderRadiusValue;
  final double dynamicHeight;
  final double circleDiameter;
  final double iconSize;

  const TabNavBar({
    super.key,
    required this.navigationShell,
    required this.borderRadiusValue,
    required this.dynamicHeight,
    required this.circleDiameter,
    required this.iconSize,
  });

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('tabNavBar'),
      height: dynamicHeight,
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        boxShadow: CustomNavBar.doubleShadow,
      ),
      padding: const .symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: .center,
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          NavBarItem(
            index: 0,
            isSelected: navigationShell.currentIndex == 0,
            onTap: () => _onTabSelected(0),
            circleDiameter: circleDiameter,
            iconSize: iconSize,
          ),
          NavBarItem(
            index: 1,
            isSelected: navigationShell.currentIndex == 1,
            onTap: () => _onTabSelected(1),
            circleDiameter: circleDiameter,
            iconSize: iconSize,
          ),
          NavBarItem(
            index: 2,
            isSelected: navigationShell.currentIndex == 2,
            onTap: () => _onTabSelected(2),
            circleDiameter: circleDiameter,
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }
}
