import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Stats & Settings',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}
