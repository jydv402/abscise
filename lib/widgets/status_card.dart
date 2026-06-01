import 'package:abscise/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String startIcon;
  final Color? iconColor;
  final bool? isClickable;
  final String? endIcon;
  final bool? isFirst;
  final bool? isLast;

  const StatusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.startIcon,
    this.iconColor = AppTheme.tertiaryLime,
    this.isClickable = false,
    this.endIcon = Ph.caret_right_duotone,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(top: 4),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.secondaryPurple,
        borderRadius: isFirst!
            ? isLast!
                  ? .vertical(top: .circular(4), bottom: .circular(4))
                  : .vertical(
                      top: .circular(AppTheme.borderRadius),
                      bottom: .circular(4),
                    )
            : .vertical(
                top: .circular(4),
                bottom: .circular(AppTheme.borderRadius),
              ),
      ),
      child: Row(
        children: [
          Iconify(startIcon, color: iconColor, size: 32),
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
          if (isClickable!) ...[
            Iconify(endIcon!, color: AppTheme.tertiaryLime, size: 16),
          ],
        ],
      ),
    );
  }
}
