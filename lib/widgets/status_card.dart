import 'package:abscise/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconifyIcon;
  final Color iconColor;

  const StatusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconifyIcon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Row(
        children: [
          Iconify(iconifyIcon, color: iconColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
