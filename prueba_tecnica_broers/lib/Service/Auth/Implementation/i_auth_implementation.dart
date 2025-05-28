// lib/Service/Auth/Implementation/i_auth_implementation.dart
// filepath: c:\Users\Catalina\Desktop\BROERS---Prueba-Tecnica\prueba_tecnica_broers\lib\Service\Auth\Implementation\i_auth_implementation.dart
import 'package:prueba_tecnica_broers/Models/user_model.dart';
import 'package:prueba_tecnica_broers/Service/Auth/Implementation/fake_auth_repository.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Instancia del repositorio que simula la API
  final FakeAuthRepository _repository = FakeAuthRepository();

  // Login con lógica de negocio
  static Future<({String message, bool success, UserModel? user})> login({
    required String username,
    String? password, // Mantener compatibilidad
  }) async {
    final service = AuthService();

    try {
      // Validaciones de negocio ANTES de llamar al repository
      if (username.trim().isEmpty) {
        return (
          success: false,
          message: 'El nombre de usuario es requerido',
          user: null,
        );
      }

      if (username.trim().length < 2) {
        return (
          success: false,
          message: 'El nombre de usuario debe tener al menos 2 caracteres',
          user: null,
        );
      }

      if (!isValidUsername(username)) {
        return (
          success: false,
          message: 'El nombre de usuario contiene caracteres inválidos',
          user: null,
        );
      }

      // Llamar al repositorio (simulación de API)
      final response = await service._repository.login(username.trim());

      if (response['success'] == true) {
        final userData = response['data']['user'];
        final user = UserModel(
          id: userData['id'],
          username: userData['username'],
          createdAt: DateTime.parse(userData['createdAt']),
        );

        // Variable tipada para evitar problemas de inferencia
        final result = (
          success: true,
          message: response['message'] as String? ?? 'Login exitoso',
          user: user as UserModel?,
        );
        return result;
      } else {
        // Variable tipada para evitar problemas de inferencia
        final result = (
          success: false,
          message: response['message'] as String? ?? 'Error en el login',
          user: null as UserModel?,
        );
        return result;
      }
    } catch (e) {
      return (success: false, message: _getErrorMessage(e), user: null);
    }
  }

  // Logout con lógica de negocio
  static Future<bool> logout() async {
    final service = AuthService();

    try {
      return await service._repository.logout();
    } catch (e) {
      // Log error pero no fallar el logout
      print('Error durante logout: $e');
      return false;
    }
  }

  // Verificar si está logueado
  static Future<bool> isLoggedIn() async {
    final service = AuthService();

    try {
      return await service._repository.isLoggedIn();
    } catch (e) {
      // En caso de error, asumir que no está logueado
      return false;
    }
  }

  // Obtener usuario actual
  static Future<UserModel?> getCurrentUser() async {
    final service = AuthService();

    try {
      return await service._repository.getCurrentUser();
    } catch (e) {
      // Si hay error, no hay usuario
      return null;
    }
  }

  // Auto-login con lógica de negocio
  static Future<({bool success, String message, UserModel? user})>
  autoLogin() async {
    final service = AuthService();

    try {
      final response = await service._repository.autoLogin();

      if (response == null || response['success'] != true) {
        final result = (
          success: false,
          message: 'No hay sesión guardada',
          user: null as UserModel?,
        );
        return result;
      }

      final userData = response['data']['user'];
      final user = UserModel(
        id: userData['id'],
        username: userData['username'],
        createdAt: DateTime.parse(userData['createdAt']),
      );

      final result = (
        success: true,
        message: response['message'] as String? ?? 'Sesión restaurada',
        user: user as UserModel?,
      );
      return result;
    } catch (e) {
      final result = (
        success: false,
        message: _getErrorMessage(e),
        user: null as UserModel?,
      );
      return result;
    }
  }

  // Forgot Password (simulado)
  static Future<({bool success, String message})> forgotPassword({
    required String username,
  }) async {
    try {
      // Validaciones de negocio
      if (username.trim().isEmpty) {
        return (success: false, message: 'El nombre de usuario es requerido');
      }

      // Simular delay de API
      await Future.delayed(const Duration(milliseconds: 1000));

      return (
        success: true,
        message: 'Si el usuario existe, recibirás instrucciones por email',
      );
    } catch (e) {
      return (success: false, message: _getErrorMessage(e));
    }
  }

  // Validar formato de username
  static bool isValidUsername(String username) {
    final trimmed = username.trim();
    return trimmed.isNotEmpty &&
        trimmed.length >= 2 &&
        trimmed.length <= 50 &&
        RegExp(r'^[a-zA-Z0-9_\-\s]+$').hasMatch(trimmed);
  }

  // Obtener información de sesión (para debugging)
  static Future<Map<String, dynamic>> getSessionInfo() async {
    final service = AuthService();

    try {
      return await service._repository.getSessionInfo();
    } catch (e) {
      return {'error': true, 'message': _getErrorMessage(e)};
    }
  }

  // Helper para obtener mensajes de error legibles
  static String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return error.toString();
  }

  // Limpiar sesión por completo (para casos extremos)
  static Future<bool> clearSession() async {
    final service = AuthService();

    try {
      await service._repository.logout();
      return true;
    } catch (e) {
      return false;
    }
  }
}
