import 'package:abscise/widgets/message_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../../core/themes/app_theme.dart';
import '../../../widgets/stack_button.dart';

class GooglePrivacyScreen extends StatelessWidget {
  const GooglePrivacyScreen({super.key});

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String content,
    required String iconPath,
    required Color iconColor,
  }) {
    return MessageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            children: [
              Iconify(iconPath, color: iconColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          Text(
            content,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: ListView(
        padding: AppTheme.topPadding,
        children: [
          // Header Row with Back Button
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppTheme.surfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Iconify(
                    Ph.arrow_left_bold,
                    color: AppTheme.primaryPurple,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Google Photos Terms & Policy',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Intro text
          Text(
            'This Privacy Policy and Terms of Use govern the connection and synchronization between the Abscise application and your Google Photos Library using Google OAuth APIs. Please read these terms carefully before authorizing access.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textWhite.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),

          // Scopes & API Access
          _buildSectionCard(
            context,
            title: 'Scoped OAuth Permissions',
            content:
                'Abscise requests restricted, secure access scopes to your Google Photos account (photoslibrary.readonly and photoslibrary.sharing) using raw Google Sign-In. These scopes are used exclusively inside the application to fetch media list ranges and organize albums. Our code operates locally and never transmits or logs your credentials or private access tokens onto external databases.',
            iconPath: Ph.key_bold,
            iconColor: AppTheme.primaryPurple,
          ),

          // Zero Cloud Deletions Guarantee
          _buildSectionCard(
            context,
            title: 'Zero Cloud Deletion Guarantee',
            content:
                'Abscise will NEVER delete, edit, or modify original files from your Google Cloud storage. The Google Photos API restricts permanent deletions. To protect your library, swiped-left files are only added/synced into a new Google Photos Album created inside your account named "Abscise Bin". You retain absolute final control to review, restore, or manually delete these remote photos directly within your official Google Photos account.',
            iconPath: Ph.shield_check_bold,
            iconColor: AppTheme.keepGreen,
          ),

          // Third-Party Authentication & Audit logs
          _buildSectionCard(
            context,
            title: 'Google Consent & Audit Logs',
            content:
                'Your authentication is verified and secured by Google. When logging in, you explicitly authorize Abscise on Google\'s own secure servers. Google logs and records this authorization under your Google Account Security Dashboard, where you retain the absolute right to revoke access at any moment. Google\'s server-side authorization log stands as third-party, legally binding proof of your active consent.',
            iconPath: Ph.file_text_bold,
            iconColor: AppTheme.tertiaryLime,
          ),

          // Limitation of Liability
          Container(
            margin: .only(top: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              border: Border.all(
                color: AppTheme.deleteRed.withValues(alpha: 0.3),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Row(
                  children: [
                    const Iconify(
                      Ph.warning_bold,
                      color: AppTheme.deleteRed,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'DISCLAIMER & LIABILITY LIMITS',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.deleteRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'THIS GOOGLE SYNC OPTION IS PROVIDED "AS-IS" WITHOUT WARRANTY OF ANY SORT. THE DEVELOPER ASSUMES ZERO RESPONSIBILITY FOR REMOTELY CREATED ALBUMS, SYNC FAILURES, NETWORK INTERRUPTIONS, OAUTH EXPIRATIONS, REMOTE API DEPRECATIONS, OR ACTIONS COMPLETED BY THE USER INSIDE THE GOOGLE PHOTOS ALBUMS.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: StackButton(
        label: 'Accept & Return',
        iconifyIcon: Ph.check_bold,
        onPressed: () => context.pop(true),
        variant: ButtonVariant.primary,
      ),
      floatingActionButtonLocation: .centerFloat,
    );
  }
}
