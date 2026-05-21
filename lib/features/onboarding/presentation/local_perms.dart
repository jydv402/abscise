import 'package:abscise/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/icons/ph.dart';

class LocalPermsScreen extends StatelessWidget {
  const LocalPermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: const Text('Grant Local Permissions (Placeholder)')),
      floatingActionButton: PrimaryButton(
        label: "Allow Everything",
        iconifyIcon: Ph.check_square_offset,
        onPressed: () => context.go('/local'),
      ),
      floatingActionButtonLocation: .centerFloat,
    );
  }
}
