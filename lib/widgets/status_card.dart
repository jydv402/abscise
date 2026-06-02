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
  final VoidCallback? onTap;

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
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadiusVal = isFirst!
        ? isLast!
              ? const .vertical(top: .circular(4), bottom: .circular(4))
              : .vertical(
                  top: .circular(AppTheme.borderRadius),
                  bottom: const .circular(4),
                )
        : .vertical(
            top: const .circular(4),
            bottom: .circular(AppTheme.borderRadius),
          );

    final Widget cardContent = Row(
      children: [
        Iconify(startIcon, color: iconColor, size: 32),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            spacing: 4,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: .w500,
                ),
              ),
            ],
          ),
        ),
        if (isClickable!) ...[
          Iconify(endIcon!, color: AppTheme.tertiaryLime, size: 16),
        ],
      ],
    );

    return Container(
      margin: const .only(top: 4),
      decoration: BoxDecoration(
        color: AppTheme.secondaryPurple,
        borderRadius: borderRadiusVal,
      ),
      child: isClickable!
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: borderRadiusVal,
                child: Padding(padding: const .all(24), child: cardContent),
              ),
            )
          : Padding(padding: const .all(24), child: cardContent),
    );
  }
}
