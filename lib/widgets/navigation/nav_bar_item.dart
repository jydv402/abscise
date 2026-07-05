import 'package:abscise/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

class NavBarItem extends StatelessWidget {
  const NavBarItem({
    super.key,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.circleDiameter,
    required this.iconSize,
  });
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final double circleDiameter;
  final double iconSize;

  static const List<String> activeIcons = [
    Ph.file_image_duotone,
    Ph.trash_duotone,
    Ph.graph_duotone,
  ];

  static const List<String> inactiveIcons = [
    Ph.file_image_bold,
    Ph.trash_bold,
    Ph.graph_bold,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: circleDiameter,
        height: circleDiameter,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.darkBackground : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Iconify(
            isSelected ? activeIcons[index] : inactiveIcons[index],
            color: isSelected ? AppTheme.tertiaryLime : AppTheme.darkBackground,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
