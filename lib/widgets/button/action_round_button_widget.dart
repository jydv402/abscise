import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../themes/app_theme.dart';
import '../navigation/nav_bar_widget.dart';

class ActionRoundButton extends StatelessWidget {
  final VoidCallback onTap;
  final double dynamicHeight;
  final double circleDiameter;
  final double iconSize;
  final String icon;

  const ActionRoundButton({
    super.key,
    required this.onTap,
    required this.dynamicHeight,
    required this.circleDiameter,
    required this.iconSize,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: dynamicHeight,
        height: dynamicHeight,
        decoration: BoxDecoration(
          color: AppTheme.primaryPurple,
          shape: BoxShape.circle,
          boxShadow: CustomNavBar.doubleShadow,
        ),
        child: Center(
          child: Container(
            width: circleDiameter,
            height: circleDiameter,
            decoration: const BoxDecoration(
              color: AppTheme.darkBackground,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Iconify(
                icon,
                color: AppTheme.tertiaryLime,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
