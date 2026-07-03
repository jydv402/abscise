import 'package:abscise/providers/shared_prefs_provider.dart';
import 'package:abscise/widgets/stack_button_widget.dart';
import 'package:abscise/widgets/status_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:abscise/themes/app_theme.dart';
// import 'package:abscise/controllers/google_auth_controller.dart';
import 'package:abscise/controllers/local_perms_controller.dart';
// import 'package:abscise/models/google_auth_state.dart';
import 'package:abscise/models/local_perms_state.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppTheme.paddingL,
      physics: const BouncingScrollPhysics(),
      children: const [
        _SectionHeading(title: 'Stats'),
        _SpaceSavedBox(),
        _StorageAccessStatusCard(),
        // _GooglePhotosStatusCard(),
        // SizedBox(height: 36),
        // _SectionHeading(title: 'Google Account Settings'),
        // _GoogleAccountSettingsSection(),
        SizedBox(height: 36),
        _SectionHeading(title: 'Select Ordering'),
        _SelectOrderingSection(),
        SizedBox(height: 36),
        _SectionHeading(title: 'Privacy Policy'),
        _PrivacyPolicySection(),
        SizedBox(height: 36),
        _SectionHeading(title: 'About'),
        _AboutSection(),
      ],
    );
  }
}

/// Select Ordering Section
class _SelectOrderingSection extends ConsumerWidget {
  const _SelectOrderingSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAscending = ref.watch(mediaFetchAscendingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatusCard(
          title: 'Oldest First (Ascending)',
          subtitle: 'Load media items from oldest to newest',
          startIcon: Ph.sort_ascending_duotone,
          isClickable: true,
          endIcon: isAscending ? Ph.check_square_fill : Ph.square,
          isFirst: true,
          isLast: false,
          onTap: () {
            ref.read(mediaFetchAscendingProvider.notifier).setOrder(true);
          },
        ),
        StatusCard(
          title: 'Newest First (Descending)',
          subtitle: 'Load media items from newest to oldest',
          startIcon: Ph.sort_descending_duotone,
          isClickable: true,
          endIcon: !isAscending ? Ph.check_square_fill : Ph.square,
          isFirst: false,
          isLast: true,
          onTap: () {
            ref.read(mediaFetchAscendingProvider.notifier).setOrder(false);
          },
        ),
      ],
    );
  }
}

/// Section Header builder widget
class _SectionHeading extends StatelessWidget {
  final String title;

  const _SectionHeading({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: 16),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

/// Space saved box
class _SpaceSavedBox extends ConsumerWidget {
  const _SpaceSavedBox();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Isolated listen: Only rebuilds when memorySaved values shift
    final memorySaved = ref.watch(memorySavedProvider);

    return Container(
      padding: const .all(24),
      decoration: BoxDecoration(
        color: AppTheme.secondaryPurple,
        borderRadius: .vertical(
          top: .circular(AppTheme.borderRadius),
          bottom: .circular(4),
        ),
      ),
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
    );
  }
}

/// Storage access status card
class _StorageAccessStatusCard extends ConsumerWidget {
  const _StorageAccessStatusCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStorageGranted = ref.watch(
      permsControllerProvider.select((s) => s.status == PermStatus.granted),
    );

    return StatusCard(
      title: 'Storage Access',
      subtitle: isStorageGranted
          ? 'Granted access to your local media library.'
          : 'Local storage permission is denied.',
      startIcon: isStorageGranted ? Ph.check_bold : Ph.warning_bold,
      iconColor: isStorageGranted ? AppTheme.keepGreen : AppTheme.deleteRed,
      isFirst: false,
      isLast: true,
    );
  }
}

// /// Google Photos Access status card
// class _GooglePhotosStatusCard extends ConsumerWidget {
//   const _GooglePhotosStatusCard();
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final googleAuthState = ref.watch(googleAuthControllerProvider);
//     final isGoogleAuthenticated =
//         googleAuthState.status == AuthStatus.authenticated;
//
//     final prefs = ref.watch(appPreferencesProvider);
//     final cachedEmail = prefs.getGoogleUserEmail();
//
//     return StatusCard(
//       title: 'Google Photos Sync',
//       subtitle: isGoogleAuthenticated
//           ? 'Connected: ${googleAuthState.user?.email ?? cachedEmail ?? "Account linked"}'
//           : 'Not Connected (Onboarding Skipped)',
//       startIcon: isGoogleAuthenticated
//           ? Ph.google_photos_logo_duotone
//           : Ph.google_photos_logo,
//       iconColor: isGoogleAuthenticated
//           ? AppTheme.keepGreen
//           : AppTheme.deleteRed,
//     );
//   }
// }
//
// /// Google Account settings section
// class _GoogleAccountSettingsSection extends ConsumerWidget {
//   const _GoogleAccountSettingsSection();
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final googleAuthState = ref.watch(googleAuthControllerProvider);
//     final isGoogleAuthenticated =
//         googleAuthState.status == AuthStatus.authenticated;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (!isGoogleAuthenticated)
//           const _UnauthenticatedSettingsBox()
//         else
//           _AuthenticatedSettingsBox(googleUser: googleAuthState.user),
//       ],
//     );
//   }
// }
//
// /// Unauthenticated settings section
// class _UnauthenticatedSettingsBox extends StatelessWidget {
//   const _UnauthenticatedSettingsBox();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: AppTheme.secondaryPurple,
//         borderRadius: BorderRadius.circular(AppTheme.borderRadius),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         spacing: 16,
//         children: [
//           Row(
//             children: [
//               const Iconify(
//                 Ph.google_logo_bold,
//                 color: AppTheme.tertiaryLime,
//                 size: 28,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Link Google Photos',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             ],
//           ),
//           Text(
//             'Link your Google Photos library to manage your remote assets, swipe to clean duplicates, and free up cloud workspace storage.',
//             style: Theme.of(context).textTheme.titleSmall?.copyWith(
//               color: AppTheme.textSecondary,
//               fontWeight: .w500,
//             ),
//           ),
//           StackButton(
//             label: 'Link Account',
//             iconifyIcon: Ph.arrow_arc_right,
//             variant: ButtonVariant.tertiary,
//             onPressed: () => context.go('/google-auth'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Authenticated settings section
// class _AuthenticatedSettingsBox extends ConsumerWidget {
//   final dynamic googleUser;
//
//   const _AuthenticatedSettingsBox({required this.googleUser});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final prefs = ref.watch(appPreferencesProvider);
//     final cachedName = prefs.getGoogleUserName();
//     final cachedEmail = prefs.getGoogleUserEmail();
//
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: AppTheme.secondaryPurple,
//         borderRadius: BorderRadius.circular(AppTheme.borderRadius),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         spacing: 24,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             spacing: 4,
//             children: [
//               Text(
//                 googleUser?.displayName ?? cachedName ?? 'Authenticated User',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               Text(
//                 googleUser?.email ?? cachedEmail ?? '',
//                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                   color: AppTheme.textSecondary,
//                   fontWeight: .w500,
//                 ),
//               ),
//             ],
//           ),
//           const Divider(color: AppTheme.surfaceColor, height: 1),
//
//           // Switch Account Action
//           _ActionRow(
//             title: 'Switch Google Library',
//             description:
//                 'Switch accounts to link a different Google Photos library and manage its media instead.',
//             buttonLabel: 'Switch Account',
//             onPressed: () async {
//               await ref.read(googleAuthControllerProvider.notifier).logout();
//               if (context.mounted) context.go('/google-auth');
//             },
//           ),
//           const Divider(color: AppTheme.surfaceColor, height: 1),
//
//           // Log Out Action
//           _ActionRow(
//             title: 'Revoke Integration',
//             description:
//                 'Disconnect from Google Photos completely. Your local photos will remain untouched.',
//             buttonLabel: 'Log Out',
//             onPressed: () async {
//               await ref.read(googleAuthControllerProvider.notifier).logout();
//               if (context.mounted) context.go('/google-auth');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Action Row Widget
// class _ActionRow extends StatelessWidget {
//   final String title;
//   final String description;
//   final String buttonLabel;
//   final VoidCallback onPressed;
//
//   const _ActionRow({
//     required this.title,
//     required this.description,
//     required this.buttonLabel,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       spacing: 12,
//       children: [
//         Text(title, style: Theme.of(context).textTheme.titleMedium),
//         Text(
//           description,
//           style: Theme.of(context).textTheme.titleSmall?.copyWith(
//             color: AppTheme.textSecondary,
//             fontWeight: .w500,
//           ),
//         ),
//         StackButton(
//           label: buttonLabel,
//           iconifyIcon: Ph.arrow_arc_right,
//           variant: ButtonVariant.tertiary,
//           onPressed: onPressed,
//         ),
//       ],
//     );
//   }
// }

// Goto Privacy Policy Section
class _PrivacyPolicySection extends StatelessWidget {
  const _PrivacyPolicySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatusCard(
          title: 'Local Privacy Policy',
          subtitle: 'See Local Privacy Policy',
          startIcon: Ph.device_mobile_duotone,
          isClickable: true,
          onTap: () {
            context.push('/local-privacy');
          },
          isFirst: true,
          isLast: true,
        ),
        // StatusCard(
        //   title: 'Google Photos Privacy Policy',
        //   subtitle: 'See Google Photos Privacy Policy',
        //   startIcon: Ph.cloud_duotone,
        //   isLast: true,
        //   isClickable: true,
        //   onTap: () {
        //     context.push('/google-privacy');
        //   },
        // ),
      ],
    );
  }
}

/// About Section
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.secondaryPurple,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            children: [
              const Iconify(
                Ph.github_logo_bold,
                color: AppTheme.tertiaryLime,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                'Find Abscise on GitHub',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Text(
            'Abscise is built transparently and open-source. You can view the full source code, report any issues, or show support by starring the repository on GitHub.',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: .w500,
            ),
          ),
          StackButton(
            label: 'View Repository',
            iconifyIcon: Ph.arrow_arc_right,
            variant: ButtonVariant.tertiary,
            onPressed: () async {
              final Uri url = Uri.parse('https://github.com/jydv402/abscise');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
    );
  }
}
