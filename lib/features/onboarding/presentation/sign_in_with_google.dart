import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../../widgets/primary_button.dart';
import '../../../widgets/secondary_button.dart';

class SignInWithGoogleScreen extends StatelessWidget {
  const SignInWithGoogleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: .fromLTRB(16, 100, 16, 16),
        shrinkWrap: true,
        children: [
          Text(
            'Sign in with Google',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 28),
          Text(
            'To get the best experience, please sign in with your Google account.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),

      floatingActionButton: Column(
        mainAxisSize: .min,
        spacing: 12,
        children: [
          SecondaryButton(
            label: 'Skip for now',
            iconifyIcon: Ph.sign_out,
            onPressed: () => context.go('/local-perms'),
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
