import 'package:abscise/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

class TutorialButton extends StatelessWidget {
  final VoidCallback onPressed;

  const TutorialButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Iconify(Ph.info_duotone, color: AppTheme.textSecondary),
      padding: .zero,
      constraints: const BoxConstraints(),
    );
  }
}
