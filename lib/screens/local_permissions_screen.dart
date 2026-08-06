import 'package:abscise/widgets/button/stack_button_widget.dart';
import 'package:abscise/widgets/status_card_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import 'package:abscise/providers/shared_prefs_provider.dart';
import 'package:abscise/themes/app_theme.dart';
import 'package:abscise/controllers/local_permissions_controller.dart';
import 'package:abscise/models/local_perms_state.dart';

class LocalPermsScreen extends ConsumerStatefulWidget {
  const LocalPermsScreen({super.key});

  @override
  ConsumerState<LocalPermsScreen> createState() => _LocalPermsScreenState();
}

class _LocalPermsScreenState extends ConsumerState<LocalPermsScreen>
    with WidgetsBindingObserver {
  bool _consentAccepted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _consentAccepted = ref
              .read(appPreferencesProvider)
              .getLocalConsentAccepted();
        });
      }
    });
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
        context.go('/local'); // Proceeds to the home screen
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
        padding: AppTheme.paddingXL,
        children: [
          const SizedBox(height: 48),
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

          // App Features explanation cards
          Padding(
            padding: const .fromLTRB(0, 32, 0, 16),
            child: Text(
              'Abscise makes local media decluttering quick and simple:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          StatusCard(
            title: 'Card-Deck Swipe Interface',
            subtitle:
                'Review your local photos in an interactive swipe deck. Swipe right to keep them, swipe left to queue for clean up.',
            startIcon: Ph.file_image_duotone,
            isFirst: true,
          ),
          StatusCard(
            title: 'Protected Two-Step Deletion',
            subtitle:
                'Swiped-left items are safely moved to a local Bin inside the app. They are never permanently deleted from storage without your final approval.',
            startIcon: Ph.trash_duotone,
          ),
          StatusCard(
            title: 'Absolute Device Privacy',
            subtitle:
                'Abscise runs 100% locally. Your files, library index, and swipe choices are kept securely on your offline storage and never uploaded to any remote server.',
            startIcon: Ph.device_mobile_duotone,
          ),
          StatusCard(
            title: 'Why Storage Permission is Required?',
            subtitle:
                'To load image thumbnails into your interactive swipe deck, calculate storage statistics, and move swiped-left clutter into the safe local Bin, Abscise requires standard storage permission to read and manage files in your device library.',
            startIcon: Ph.question_duotone,
            isLast: true,
          ),

          const SizedBox(height: 24),
          // Interactive Local Consent Box
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _consentAccepted,
                onChanged: isProcessing
                    ? null
                    : (val) {
                        final newValue = val ?? false;
                        setState(() {
                          _consentAccepted = newValue;
                        });
                        final prefs = ref.read(appPreferencesProvider);
                        prefs.setLocalConsentAccepted(newValue);
                        if (newValue) {
                          prefs.setLocalConsentTimestamp(
                            DateTime.now().toUtc().toIso8601String(),
                          );
                        } else {
                          prefs.setLocalConsentTimestamp(null);
                        }
                      },
                activeColor: AppTheme.primaryPurple,
                checkColor: AppTheme.darkBackground,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textWhite,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'I read and explicitly accept the '),
                      TextSpan(
                        text: 'Local Privacy Policy & Terms of Use',
                        style: const TextStyle(
                          color: AppTheme.primaryPurple,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final accepted = await context.push<bool>(
                              '/local-privacy',
                            );
                            if (accepted == true) {
                              setState(() {
                                _consentAccepted = true;
                              });
                              final prefs = ref.read(appPreferencesProvider);
                              prefs.setLocalConsentAccepted(true);
                              prefs.setLocalConsentTimestamp(
                                DateTime.now().toUtc().toIso8601String(),
                              );
                            }
                          },
                      ),
                      const TextSpan(
                        text:
                            '. I authorize Abscise to catalog my local media files strictly on-device to build the swipe cards deck.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
            onPressed: () async {
              final accepted = await context.push<bool>('/local-privacy');
              if (accepted == true) {
                setState(() {
                  _consentAccepted = true;
                });
                final prefs = ref.read(appPreferencesProvider);
                prefs.setLocalConsentAccepted(true);
                prefs.setLocalConsentTimestamp(
                  DateTime.now().toUtc().toIso8601String(),
                );
              }
            },
            variant: ButtonVariant.secondary,
          ),
          StackButton(
            label: isProcessing ? "Allowing..." : "Allow Everything",
            iconifyIcon: Ph.check_bold,
            onPressed: isProcessing
                ? () {}
                : () {
                    if (!_consentAccepted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppTheme.deleteRed,
                          content: Text(
                            'Please read and accept the Local Privacy Policy & Terms of Use first.',
                            style: TextStyle(fontFamily: 'Outfit'),
                          ),
                        ),
                      );
                      return;
                    }
                    ref
                        .read(permsControllerProvider.notifier)
                        .requestPermissions();
                  },
            variant: ButtonVariant.primary,
          ),
        ],
      ),
      floatingActionButtonLocation: .centerFloat,
    );
  }
}
