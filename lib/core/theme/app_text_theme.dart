import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'app_typography.dart';

abstract final class AppTextTheme {
  static TextTheme get light {
    return const TextTheme(
      displayLarge: AppTypography.headingLarge,
      displayMedium: AppTypography.headingMedium,
      titleLarge: AppTypography.title,
      bodyLarge: AppTypography.body,
      bodyMedium: AppTypography.body,
      bodySmall: AppTypography.caption,
    ).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );
  }
}