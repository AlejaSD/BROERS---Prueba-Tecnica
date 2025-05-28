import 'package:flutter/material.dart';

class AppColors {
  // Paleta de colores principal
  static const Color primaryBase = Color(0xFFE0BBE4);
  static const Color background = Color(0xFFFEF9FF);
  static const Color inputBackground = Color(0xFFD4C1EC);
  static const Color inputBorder = Color(0xFF9F9FED);
  static const Color actionButton = Color(0xFF736CED);

  // Colores adicionales
  static const Color white = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textHint = Color(0xFFA0AEC0);
  static const Color error = Color(0xFFE53E3E);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBase, inputBorder],
  );
}

class AppDimensions {
  // Padding y margins
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Espaciado específico
  static const double screenPadding = 16.0;
  static const double cardPadding = 24.0;
  static const double fieldSpacing = 24.0;

  // Tamaños de elementos
  static const double inputHeight = 48.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 20.0;
  static const double avatarSize = 80.0;
  static const double avatarIconSize = 48.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusCircle = 40.0;

  // Elevaciones
  static const double elevationCard = 8.0;
  static const double elevationButton = 4.0;

  // Anchos máximos
  static const double maxFormWidth = 400.0;
}

class AppTextStyles {
  // Títulos
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Labels y campos
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle input = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle inputHint = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
  );

  // Botones
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle linkButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.actionButton,
  );

  // Footer
  static const TextStyle footer = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}
