import 'package:abscise/widgets/message_container.dart';
import 'package:abscise/widgets/primary_button.dart';
import 'package:abscise/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../../core/themes/app_theme.dart';
import '../controllers/local_perms_controller.dart';
import '../state/local_perms_state.dart';

class LocalPermsScreen extends ConsumerWidget {
  const LocalPermsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to changes and handle navigation
    // Show error messages if permission is denied
    // Navigate to the next screen if permission is granted
    ref.listen<LocalPermsState>(permsControllerProvider, (previous, next) {
      if (next.status == PermStatus.granted) {
        context.go('/local');
      } else if (next.status == PermStatus.denied && next.errorMsg != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.deleteRed,
            content: Text(
              next.errorMsg!,
              style: const TextStyle(fontFamily: 'Outfit'),
            ),
          ),
        );
      }
    });

    final permState = ref.watch(permsControllerProvider);
    final isProcessing = permState.status == PermStatus.requesting;

    return Scaffold(
      body: ListView(
        padding: const .fromLTRB(16, 100, 16, 16),
        children: [
          Text(
            'Grant Permissions',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          MessageContainer(
            child: Text(
              'To index your photos and media items and to clean them, Abscise requires local media storage permissions. Please grant access to your device\'s media library to proceed.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: .min,
        spacing: 12,
        children: [
          SecondaryButton(
            label: "Go back",
            iconifyIcon: Ph.arrow_arc_left,
            onPressed: () => context.go('/google-sign'),
          ),
          PrimaryButton(
            label: isProcessing ? "Allowing..." : "Allow Everything",
            iconifyIcon: Ph.check_bold,
            onPressed: isProcessing
                ? () {}
                : () => ref
                      .read(permsControllerProvider.notifier)
                      .requestPermissions(),
          ),
        ],
      ),
      floatingActionButtonLocation: .centerFloat,
    );
  }
}
