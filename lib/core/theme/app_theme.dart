import 'package:flutter/material.dart';
import 'package:fit_mate_client/core/constants/color_constants.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorConstants.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: ColorConstants.background,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: ColorConstants.background,
        foregroundColor: ColorConstants.textPrimary,
      ),
    );
  }
}
