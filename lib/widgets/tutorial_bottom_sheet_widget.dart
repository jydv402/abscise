import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../themes/app_theme.dart';
import 'button/stack_button_widget.dart';

class TutorialInstruction {
  final String icon;
  final String title;
  final String description;

  const TutorialInstruction({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class TutorialBottomSheet extends StatelessWidget {
  final String title;
  final List<TutorialInstruction> instructions;

  const TutorialBottomSheet({
    super.key,
    required this.title,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: const BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Iconify(
                  Ph.info_duotone,
                  color: AppTheme.tertiaryLime,
                  size: 48,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ...instructions.map(
              (inst) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  crossAxisAlignment: .center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Iconify(
                        inst.icon,
                        color: AppTheme.darkBackground,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inst.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            inst.description,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            StackButton(
              label: 'Got it!',
              iconifyIcon: Ph.check_bold,
              onPressed: () => Navigator.of(context).pop(),
              variant: ButtonVariant.primary,
            ),
          ],
        ),
      ),
    );
  }
}
