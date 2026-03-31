import 'package:flutter/material.dart';

class ResultPlaceholderSection extends StatelessWidget {
  const ResultPlaceholderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Result feature placeholder'),
      ),
    );
  }
}
