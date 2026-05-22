import 'package:abscise/core/themes/app_theme.dart';
import 'package:flutter/material.dart';

class BinScreen extends StatelessWidget {
  const BinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppTheme.topPadding,
      children: [Text('Bin', style: Theme.of(context).textTheme.headlineLarge)],
    );
  }
}
