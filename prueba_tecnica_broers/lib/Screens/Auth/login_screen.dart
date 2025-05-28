import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Agregar este import
import 'package:prueba_tecnica_broers/Screens/Auth/login_styles.dart';
import 'package:prueba_tecnica_broers/Widgets/Auth/custom_buttom.dart';
import 'package:prueba_tecnica_broers/Widgets/Auth/custom_text_field.dart';
import 'package:prueba_tecnica_broers/Widgets/Auth/login_header.dart';
import 'package:prueba_tecnica_broers/Service/Auth/Implementation/i_auth_implementation.dart';
import 'package:prueba_tecnica_broers/Providers/auth_provider.dart'; // Agregar este import

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Verificar auto-login al cargar la pantalla
    //_checkAutoLogin();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simular proceso de login y guardar sesión
      final result = await AuthService.login(
        username: _usernameController.text.trim(),
      );

      if (mounted) {
        if (result.success) {
          // Actualizar el provider con el usuario logueado
          ref
              .read(authProvider.notifier)
              .login(_usernameController.text.trim());

          _showSnackBar(
            '¡Bienvenido ${_usernameController.text.trim()}!',
            isError: false,
          );

          // Esperar un poco para mostrar el mensaje
          await Future.delayed(const Duration(milliseconds: 1500));

          if (mounted) {
            // Navegar a la pantalla de tareas
            Navigator.of(context).pushReplacementNamed('/tasks');
          }
        } else {
          _showSnackBar(result.message, isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error inesperado. Intenta nuevamente.', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.actionButton,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
    );
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre de usuario es requerido';
    }
    if (value.trim().length < 2) {
      return 'El nombre de usuario debe tener al menos 2 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  (AppDimensions.screenPadding * 2),
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: AppDimensions.maxFormWidth,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header
                    const LoginHeader(),
                    const SizedBox(height: AppDimensions.paddingXL),

                    // Form Card
                    Card(
                      elevation: AppDimensions.elevationCard,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
                      ),
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          AppDimensions.cardPadding,
                        ),
                        child: Column(
                          children: [
                            // Indicador visual superior
                            Container(
                              width: double.infinity,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBase,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingL),

                            // Formulario
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Campo Username
                                  CustomTextField(
                                    label: 'Nombre de usuario',
                                    hint: 'Ingresa tu nombre',
                                    prefixIcon: Icons.person_outline,
                                    controller: _usernameController,
                                    keyboardType: TextInputType.text,
                                    validator: _validateUsername,
                                    enabled: !_isLoading,
                                  ),
                                  const SizedBox(
                                    height: AppDimensions.paddingL,
                                  ),

                                  // Botón Login
                                  CustomButton(
                                    text: 'Iniciar Sesión',
                                    onPressed: _isLoading ? null : _handleLogin,
                                    isLoading: _isLoading,
                                  ),
                                  const SizedBox(
                                    height: AppDimensions.paddingM,
                                  ),

                                  Text(
                                    'Solo necesitas tu nombre para acceder',
                                    style: AppTextStyles.linkButton.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),

                    // Footer
                    const Text(
                      'Gestor de Tareas Personal v1.0',
                      style: AppTextStyles.footer,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
