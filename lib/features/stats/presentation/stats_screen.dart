import 'package:abscise/widgets/message_container.dart';
import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppTheme.topPadding,
      children: [
        Text('Stats', style: Theme.of(context).textTheme.headlineLarge),
        MessageContainer(
          child: Column(
            spacing: 18,
            children: [
              Text(
                'Space saved so far:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                // TODO: Get this value from the backend
                '67.00 MB',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text('Settings', style: Theme.of(context).textTheme.headlineLarge),
        // TODO: Add app settings, permission status, google account revoke option, login with another account option, etc.
      ],
    );
  }
}
