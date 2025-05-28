import 'package:flutter/material.dart';
import 'package:prueba_tecnica_broers/Screens/Auth/login_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double? height;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppDimensions.buttonHeight,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.actionButton, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                elevation: 0,
              ),
              child: _buildButtonContent(isOutlined: true),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.actionButton,
                foregroundColor: AppColors.white,
                elevation: AppDimensions.elevationButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                disabledBackgroundColor: AppColors.actionButton.withOpacity(
                  0.7,
                ),
              ),
              child: _buildButtonContent(),
            ),
    );
  }

  Widget _buildButtonContent({bool isOutlined = false}) {
    if (isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined ? AppColors.actionButton : AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Text(
            'Iniciando sesión...',
            style: isOutlined ? AppTextStyles.linkButton : AppTextStyles.button,
          ),
        ],
      );
    }

    return Text(
      text,
      style: isOutlined ? AppTextStyles.linkButton : AppTextStyles.button,
    );
  }
}
