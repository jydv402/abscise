import 'package:abscise/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

enum ButtonVariant { primary, secondary }

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
    final isPrimary = variant == ButtonVariant.primary;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.85,
            height: 75,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: isPrimary
                  ? AppTheme.primaryPurple
                  : AppTheme.darkBackground,
              border: isPrimary
                  ? null
                  : Border.all(color: AppTheme.tertiaryLime, width: 2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              label,
              style: AppTheme.darkTheme.textTheme.bodyLarge!.copyWith(
                color: isPrimary
                    ? AppTheme.darkBackground
                    : AppTheme.tertiaryLime,
              ),
            ),
          ),
          Positioned(
            left: 28,
            top: 23.5,
            child: Iconify(
              iconifyIcon,
              color: isPrimary
                  ? AppTheme.darkBackground
                  : AppTheme.tertiaryLime,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
