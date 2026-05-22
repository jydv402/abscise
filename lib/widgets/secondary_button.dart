import 'package:abscise/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final String iconifyIcon;
  final VoidCallback onPressed;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.iconifyIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        children: [
          Container(
            alignment: .center,
            width: MediaQuery.of(context).size.width * 0.85,
            height: 75,
            padding: const .symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: AppTheme.tertiaryLime, width: 2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              label,
              style: AppTheme.darkTheme.textTheme.bodyLarge!.copyWith(
                color: AppTheme.tertiaryLime,
              ),
            ),
          ),
          Positioned(
            left: 28,
            top: 23.5,
            child: Iconify(iconifyIcon, color: AppTheme.tertiaryLime, size: 28),
          ),
        ],
      ),
    );
  }
}
