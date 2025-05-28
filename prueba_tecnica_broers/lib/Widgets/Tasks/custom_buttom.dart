import 'package:flutter/material.dart';
import 'package:prueba_tecnica_broers/Screens/Tasks/task_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.action;
    final txtColor = textColor ?? AppColors.white;

    return SizedBox(
      width: width,
      height: height ?? AppDimensions.buttonHeight,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : (icon != null
                        ? Icon(icon, size: AppDimensions.iconS)
                        : const SizedBox.shrink()),
              label: Text(text),
              style: OutlinedButton.styleFrom(
                foregroundColor: bgColor,
                side: BorderSide(color: bgColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                textStyle: AppTextStyles.button,
              ),
            )
          : ElevatedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  : (icon != null
                        ? Icon(icon, size: AppDimensions.iconS)
                        : const SizedBox.shrink()),
              label: Text(text),
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: txtColor,
                elevation: AppDimensions.elevationLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                textStyle: AppTextStyles.button,
              ),
            ),
    );
  }
}
