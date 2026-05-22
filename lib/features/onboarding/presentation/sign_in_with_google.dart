import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../../core/themes/app_theme.dart';
import '../../../widgets/message_container.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/secondary_button.dart';

class SignInWithGoogleScreen extends StatelessWidget {
  const SignInWithGoogleScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              'To get the best experience, please sign in with your Google account.',
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
            onPressed: () => context.go('/local'),
          ),
          PrimaryButton(
            label: 'Continue with Google',
            iconifyIcon: Ph.google_logo_bold,
            onPressed: () {}, // TODO: Implement Google Sign-In
          ),
        ],
      ),
      floatingActionButtonLocation: .centerFloat,
    );
  }
}
