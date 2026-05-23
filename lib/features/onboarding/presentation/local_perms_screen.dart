import 'package:abscise/widgets/message_container.dart';
import 'package:abscise/widgets/stack_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../../core/providers/shared_prefs_provider.dart';
import '../../../core/themes/app_theme.dart';
import '../controllers/google_auth_controller.dart';
import '../controllers/local_perms_controller.dart';
import '../state/google_auth_state.dart';
import '../state/local_perms_state.dart';

class LocalPermsScreen extends ConsumerStatefulWidget {
  const LocalPermsScreen({super.key});

  @override
  ConsumerState<LocalPermsScreen> createState() => _LocalPermsScreenState();
}

class _LocalPermsScreenState extends ConsumerState<LocalPermsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(permsControllerProvider.notifier).checkPermissionsStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes and handle navigation
    // Show error messages if permission is denied
    // Navigate to the next screen if permission is granted
    ref.listen<LocalPermsState>(permsControllerProvider, (previous, next) {
      if (next.status == PermStatus.granted) {
        final prefs = ref.read(appPreferencesProvider);
        final alreadySkipped = prefs.getGoogleAuthSkipped();
        final googleAuthState = ref.read(googleAuthControllerProvider);
        final alreadyAuthenticated =
            googleAuthState.status == AuthStatus.authenticated;

        if (alreadySkipped || alreadyAuthenticated) {
          context.go('/local');
        } else {
          context.go('/google-auth');
        }
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
        padding: AppTheme.topPadding,
        children: [
          Text(
            'Grant Permissions',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          if (permState.status == PermStatus.denied) ...[
            const SizedBox(height: 24),
            Container(
              padding: const .all(24),
              decoration: BoxDecoration(
                color: AppTheme.deleteRed,
                //border: Border.all(color: AppTheme.deleteRed, width: 2),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Row(
                    children: [
                      const Iconify(
                        Ph.warning,
                        color: AppTheme.textWhite,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Permission Required',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: AppTheme.textWhite),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'You previously denied storage permissions. To continue, you must open your system settings, enable permission access, and set it to Allow All / Allow access to all photos.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textWhite.withValues(alpha: 0.9),
                    ),
                  ),
                  InkWell(
                    onTap: isProcessing
                        ? null
                        : () => ref
                              .read(permsControllerProvider.notifier)
                              .openAppSettings(),
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const .symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.deleteRed,
                        border: Border.all(color: AppTheme.textWhite),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: .min,
                        children: [
                          const Iconify(
                            Ph.gear_six_fill,
                            color: AppTheme.textWhite,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Go to Settings',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppTheme.textWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          StackButton(
            label: "See privacy policy",
            iconifyIcon: Ph.arrow_bend_double_up_right,
            onPressed: () {},
            variant: ButtonVariant.secondary,
          ),
          StackButton(
            label: isProcessing ? "Allowing..." : "Allow Everything",
            iconifyIcon: Ph.check_bold,
            onPressed: isProcessing
                ? () {}
                : () => ref
                      .read(permsControllerProvider.notifier)
                      .requestPermissions(),
            variant: ButtonVariant.primary,
          ),
        ],
      ),
      floatingActionButtonLocation: .centerFloat,
    );
  }
}
