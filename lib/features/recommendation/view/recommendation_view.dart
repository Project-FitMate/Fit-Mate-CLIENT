import 'package:flutter/material.dart';
import 'package:fit_mate_client/features/recommendation/widget/recommendation_placeholder_section.dart';

class RecommendationView extends StatelessWidget {
  const RecommendationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recommendation')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: RecommendationPlaceholderSection(),
      ),
    );
  }
}
