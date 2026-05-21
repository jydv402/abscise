import 'package:flutter/material.dart';

class CloudScreen extends StatelessWidget {
  const CloudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Google Photos',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}
