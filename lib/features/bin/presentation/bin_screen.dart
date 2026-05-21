import 'package:flutter/material.dart';

class BinScreen extends StatelessWidget {
  const BinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'The Bin',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}
