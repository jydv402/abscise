import 'package:abscise/widgets/primary_button.dart';
import 'package:abscise/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/icons/ph.dart';

class LocalPermsScreen extends StatelessWidget {
  const LocalPermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: .fromLTRB(16, 100, 16, 16),
        shrinkWrap: true,
        children: [
          Text(
            'Grant Permissions',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 28),
          Text(
            'To get the best experience, please grant the necessary permissions.',
            style: Theme.of(context).textTheme.bodyMedium,
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
            label: "Allow Everything",
            iconifyIcon: Ph.check_square_offset,
            onPressed: () => context.go('/local'),
          ),
        ],
      ),
      floatingActionButtonLocation: .centerFloat,
    );
  }
}
