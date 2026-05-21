import 'package:flutter/material.dart';

class LocalScreen extends StatelessWidget {
  const LocalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Local Photos',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}
