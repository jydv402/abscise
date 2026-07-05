import 'package:abscise/widgets/message_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import 'package:abscise/themes/app_theme.dart';
import 'package:abscise/widgets/stack_button_widget.dart';

class LocalPrivacyScreen extends StatelessWidget {
  const LocalPrivacyScreen({super.key});

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
        padding: AppTheme.paddingL,
        children: [
          // Elegant Header Row with Back Button
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
                  'Local Privacy Policy',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Policy Brief
          Text(
            'This Privacy Policy governs the local processing of storage and media libraries by the Abscise application. Please review our strict security guarantees below.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textWhite.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),

          // Section 1: Strictly On-Device Processing
          _buildSectionCard(
            context,
            title: 'On-Device Processing',
            content:
                'Abscise is built to run entirely locally. Zero bytes of your local photo library index, original image bytes, or device directory layout are transmitted, copied, or uploaded to any remote server or third-party storage. All swipe sorting operations and database indexing happen strictly on your local device sandboxed sandbox.',
            iconPath: Ph.device_mobile_bold,
            iconColor: AppTheme.primaryPurple,
          ),

          // Section 2: Two-Step Deletion Flow
          _buildSectionCard(
            context,
            title: 'Two-Step Deletion Flow',
            content:
                'Abscise does not delete files automatically. Swiping a local photo card left only queues it inside the app\'s local "Bin". To perform a permanent deletion, you must explicitly tap the "Empty Bin" button, which will then trigger your operating system\'s native system permission prompt (Android/iOS dialog) asking for final confirmation. You retain full control over all file operations.',
            iconPath: Ph.shield_check_bold,
            iconColor: AppTheme.keepGreen,
          ),

          // Section 3: No Tracking or Data Sharing
          _buildSectionCard(
            context,
            title: 'Zero Diagnostics or Tracking',
            content:
                'The developer does not collect, record, or share any personal identity, geolocation coordinates, swipe habits, storage statistics, or metadata. We use no telemetry tools or analytics services within the local operations of this app.',
            iconPath: Ph.eye_slash_bold,
            iconColor: AppTheme.tertiaryLime,
          ),

          // Section 4: Limitation of Liability (Legal Disclaimers)
          Container(
            margin: const EdgeInsets.only(top: 16),
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
                        'LIMITATION OF LIABILITY',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.deleteRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'THIS APPLICATION IS PROVIDED ON AN "AS-IS" BASIS WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED. UNDER NO CIRCUMSTANCES SHALL THE DEVELOPER BE HELD LIABLE FOR ANY ACCIDENTAL DATA CORRUPTION, LOSS OF STORAGE MEDIA, HARDWARE FAILURE, OR DIRECT/INDIRECT DAMAGES RESULTING FROM SWIPE ACTIONS OR DELETIONS COMPLETED BY THE USER.',
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
