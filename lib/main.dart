import 'package:flutter/material.dart';
import 'package:fit_mate_client/core/theme/app_theme.dart';
import 'package:fit_mate_client/features/upload/view/upload_view.dart';

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
      home: const UploadView(),
    );
  }
}
