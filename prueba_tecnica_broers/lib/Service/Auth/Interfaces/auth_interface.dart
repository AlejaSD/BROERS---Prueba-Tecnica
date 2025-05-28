// lib/Service/Auth/Interfaces/auth_interface.dart
import 'package:prueba_tecnica_broers/Models/user_model.dart';

abstract class IAuthService {
  // Login básico
  Future<Map<String, dynamic>> login(String username);
  
  // Logout
  Future<bool> logout();
  
  // Verificar sesión activa
  Future<bool> isLoggedIn();
  
  // Obtener usuario actual
  Future<UserModel?> getCurrentUser();
  
  // Auto-login (sesión persistente)
  Future<Map<String, dynamic>?> autoLogin();
  
  // Información de sesión (debugging)
  Future<Map<String, dynamic>> getSessionInfo();
}