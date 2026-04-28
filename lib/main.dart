import 'package:flutter/material.dart';
import 'package:fit_mate_client/core/theme/app_theme.dart';
import 'package:fit_mate_client/features/recommendation/model/recommended_product.dart';
import 'package:fit_mate_client/features/recommendation/view/recommendation_view.dart';

void main() {
  runApp(const FitMateApp());
}

class FitMateApp extends StatelessWidget {
  const FitMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fit Mate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RecommendationView(clothingType: ClothingType.top),
    );
  }
}
