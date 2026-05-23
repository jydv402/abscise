import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../../core/themes/app_theme.dart';
import '../../../widgets/message_container.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/secondary_button.dart';
import '../controllers/google_auth_controller.dart';
import '../state/google_auth_state.dart';

class GoogleAuthScreen extends ConsumerWidget {
  const GoogleAuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for authentication stream changes to handle reactive navigation
    ref.listen<GoogleAuthState>(googleAuthControllerProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated ||
          next.status == AuthStatus.skipped) {
        context.go('/local');
      } else if (next.status == AuthStatus.unauthenticated &&
          next.errorMsg != null) {
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

    final authState = ref.watch(googleAuthControllerProvider);
    final isProcessing = authState.status == AuthStatus.checking;

    return Scaffold(
      body: ListView(
        padding: AppTheme.topPadding,
        children: [
          Text(
            'Sign in with Google',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          MessageContainer(
            child: Text(
              'To connect your Google Photos library and clear remote clutter, authenticate your account.',
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
            label: 'Skip for now',
            iconifyIcon: Ph.arrow_arc_right,
            onPressed: isProcessing
                ? () {}
                : () {
                    ref.read(googleAuthControllerProvider.notifier).skip();
                  },
          ),
          PrimaryButton(
            label: isProcessing ? 'Logging in...' : 'Login with Google',
            iconifyIcon: Ph.google_logo_bold,
            onPressed: isProcessing
                ? () {}
                : () {
                    ref.read(googleAuthControllerProvider.notifier).login();
                  },
          ),
        ],
      ),
      floatingActionButtonLocation: .centerFloat,
    );
  }
}
