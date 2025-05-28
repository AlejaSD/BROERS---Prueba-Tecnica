import 'package:flutter/material.dart';
import 'package:prueba_tecnica_broers/Screens/Auth/login_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar con icono
        Container(
          width: AppDimensions.avatarSize,
          height: AppDimensions.avatarSize,
          decoration: const BoxDecoration(
            color: AppColors.primaryBase,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: AppDimensions.avatarIconSize,
              height: AppDimensions.avatarIconSize,
              decoration: const BoxDecoration(
                color: AppColors.actionButton,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock,
                color: AppColors.white,
                size: AppDimensions.paddingL,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingL),

        // Título
        const Text(
          'Iniciar Sesión',
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.paddingS),

        // Subtítulo
        const Text(
          'Accede a tu gestor de tareas personal',
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
