import 'package:flutter/material.dart';

class RecommendationPlaceholderSection extends StatelessWidget {
  const RecommendationPlaceholderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Recommendation feature placeholder'),
      ),
    );
  }
}
