import 'package:abscise/core/providers/shared_prefs_provider.dart';
import 'package:abscise/widgets/message_container.dart';
import 'package:abscise/widgets/stack_button.dart';
import 'package:abscise/widgets/status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../../core/themes/app_theme.dart';
import '../../onboarding/controllers/google_auth_controller.dart';
import '../../onboarding/controllers/local_perms_controller.dart';
import '../../onboarding/state/google_auth_state.dart';
import '../../onboarding/state/local_perms_state.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleAuthState = ref.watch(googleAuthControllerProvider);
    final localPermState = ref.watch(permsControllerProvider);

    final isGoogleAuthenticated =
        googleAuthState.status == AuthStatus.authenticated;
    final googleUser = googleAuthState.user;

    final isStorageGranted = localPermState.status == PermStatus.granted;

    final prefs = ref.watch(appPreferencesProvider);
    final memorySaved = prefs.getMemorySaved();
    final cachedName = prefs.getGoogleUserName();
    final cachedEmail = prefs.getGoogleUserEmail();

    return ListView(
      padding: AppTheme.topPadding,
      children: [
        // STATS SECTION
        Text('Stats', style: Theme.of(context).textTheme.headlineLarge),

        // Space Saved Stats Box
        MessageContainer(
          child: Column(
            spacing: 16,
            children: [
              Text(
                'Space saved so far:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  const Iconify(
                    Ph.star_four_duotone,
                    color: AppTheme.tertiaryLime,
                    size: 24,
                  ),
                  Text(
                    '${memorySaved.toStringAsFixed(2)} MB',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textWhite,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Iconify(
                    Ph.star_four_duotone,
                    color: AppTheme.tertiaryLime,
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Local Storage Permission Status Box
        StatusCard(
          title: 'Storage Access',
          subtitle: isStorageGranted
              ? 'Granted access to your local media library.'
              : 'Local storage permission is denied.',
          iconifyIcon: isStorageGranted ? Ph.check_bold : Ph.warning_bold,
          iconColor: isStorageGranted ? AppTheme.keepGreen : AppTheme.deleteRed,
        ),
        const SizedBox(height: 16),

        // Google Photos Connection Status Box
        StatusCard(
          title: 'Google Photos Sync',
          subtitle: isGoogleAuthenticated
              ? 'Connected: ${googleUser?.email ?? cachedEmail ?? "Account linked"}'
              : 'Not Connected (Onboarding Skipped)',
          iconifyIcon: isGoogleAuthenticated
              ? Ph.google_photos_logo_duotone
              : Ph.google_photos_logo,
          iconColor: isGoogleAuthenticated
              ? AppTheme.keepGreen
              : AppTheme.deleteRed,
        ),

        const SizedBox(height: 36),

        // SETTINGS SECTION
        Text('Settings', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),

        if (!isGoogleAuthenticated) ...[
          // Option to Connect Google Photos (if skipped or unauthenticated)
          Container(
            padding: const .all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Row(
                  children: [
                    const Iconify(
                      Ph.google_logo_bold,
                      color: AppTheme.primaryPurple,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Link Google Photos',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Text(
                  'Link your Google Photos library to manage your remote assets, swipe to clean duplicates, and free up cloud workspace storage.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                StackButton(
                  label: 'Link Account',
                  iconifyIcon: Ph.arrow_arc_right,
                  variant: ButtonVariant.tertiary,
                  onPressed: () => context.go('/google-auth'),
                ),
              ],
            ),
          ),
        ] else ...[
          // Settings Options if Connected (Logout / Sign in with another account)
          Container(
            padding: const .all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 24,
              children: [
                // User Details Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      googleUser?.displayName ??
                          cachedName ??
                          'Authenticated User',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      googleUser?.email ?? cachedEmail ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),

                const Divider(color: AppTheme.secondaryPurple, height: 1),

                // Option: Sign in with another account
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text(
                      'Switch Google Library',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Switch accounts to link a different Google Photos library and manage its media instead.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    StackButton(
                      label: 'Switch Account',
                      iconifyIcon: Ph.arrow_arc_right,
                      variant: ButtonVariant.tertiary,
                      onPressed: () async {
                        // Logout and navigate to the google sign-in screen
                        await ref
                            .read(googleAuthControllerProvider.notifier)
                            .logout();
                        if (context.mounted) {
                          context.go('/google-auth');
                        }
                      },
                    ),
                  ],
                ),

                const Divider(color: AppTheme.secondaryPurple, height: 1),

                // Option: Log Out
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text(
                      'Revoke Integration',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Disconnect from Google Photos completely. Your local photos will remain untouched.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    StackButton(
                      label: 'Log Out',
                      iconifyIcon: Ph.arrow_arc_right,
                      variant: ButtonVariant.tertiary,
                      onPressed: () async {
                        await ref
                            .read(googleAuthControllerProvider.notifier)
                            .logout();
                        if (context.mounted) {
                          context.go('/google-auth');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 100), // Push content clear of Nav Bar
      ],
    );
  }
}
