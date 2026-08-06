import 'package:flutter/material.dart';

import '../../themes/app_theme.dart';

enum PillPosition { left, middle, right, standalone }

class PillButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double height;
  final PillPosition position;
  final EdgeInsetsGeometry padding;
  final String? tooltipMessage;

  const PillButton({
    super.key,
    required this.child,
    this.onTap,
    required this.height,
    this.position = PillPosition.standalone,
    this.padding = const .symmetric(horizontal: 16),
    this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    switch (position) {
      case PillPosition.left:
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.borderRadius),
          bottomLeft: Radius.circular(AppTheme.borderRadius),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        );
        break;
      case PillPosition.middle:
        borderRadius = BorderRadius.circular(8);
        break;
      case PillPosition.right:
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          topRight: Radius.circular(AppTheme.borderRadius),
          bottomRight: Radius.circular(AppTheme.borderRadius),
        );
        break;
      case PillPosition.standalone:
        borderRadius = BorderRadius.circular(AppTheme.borderRadius);
        break;
    }

    Widget button = Material(
      color: AppTheme.darkBackground,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          alignment: Alignment.center,
          padding: padding,
          child: child,
        ),
      ),
    );

    if (tooltipMessage != null) {
      return Tooltip(message: tooltipMessage!, child: button);
    }

    return button;
  }
}
