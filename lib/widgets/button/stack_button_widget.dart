import 'package:abscise/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

enum ButtonVariant { primary, secondary, tertiary, delete }

class StackButton extends StatelessWidget {
  final String label;
  final String iconifyIcon;
  final VoidCallback onPressed;
  final ButtonVariant variant;

  const StackButton({
    super.key,
    required this.label,
    required this.iconifyIcon,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    late final Color backgroundColor;
    Border? border;
    late final Color contentColor;

    // Define the style based on the variant
    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = AppTheme.primaryPurple;
        border = null;
        contentColor = AppTheme.darkBackground;
        break;
      case ButtonVariant.tertiary:
        backgroundColor = AppTheme.surfaceColor;
        border = null;
        contentColor = AppTheme.tertiaryLime;
        break;
      case ButtonVariant.secondary:
        backgroundColor = AppTheme.darkBackground;
        border = Border.all(color: AppTheme.tertiaryLime, width: 2);
        contentColor = AppTheme.tertiaryLime;
        break;
      case ButtonVariant.delete:
        backgroundColor = AppTheme.deleteRed;
        border = null;
        contentColor = AppTheme.textWhite;
        break;
    }

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.85,
            height: 75,
            padding: const .symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: border,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              label,
              style: AppTheme.darkTheme.textTheme.bodyLarge!.copyWith(
                color: contentColor,
              ),
            ),
          ),
          Positioned(
            left: 28,
            top: 23.5,
            child: Iconify(iconifyIcon, color: contentColor, size: 28),
          ),
        ],
      ),
    );
  }
}
