import 'package:flutter/material.dart';

import 'package:abscise/themes/app_theme.dart';

class MessageContainer extends StatelessWidget {
  final Widget child;
  const MessageContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(top: 16),
      alignment: .centerStart,
      padding: const .all(24),
      decoration: BoxDecoration(
        color: AppTheme.secondaryPurple,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: child,
    );
  }
}
