import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../Interfaces/auth_interface.dart';
import '../../../Models/user_model.dart';

class FakeAuthRepository implements IAuthService {
  static const String _userKey = 'logged_user';
  static const String _sessionKey = 'user_session_active';

  @override
  Future<Map<String, dynamic>> login(String username) async {
    // Simular delay de "conexión a API" (1-2 segundos)
    await Future.delayed(Duration(milliseconds: 1000 + Random().nextInt(1000)));

    try {
      // Verificar que no esté vacío
      if (username.trim().isEmpty) {
        throw Exception('El nombre de usuario no puede estar vacío');
      }

      // Crear usuario simple con solo el nombre
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username.trim(),
        createdAt: DateTime.now(),
      );

      // Guardar en SharedPreferences para persistencia
      await _saveUserSession(user);

      // Simular respuesta exitosa de API
      return {
        'success': true,
        'message': 'Sesión iniciada exitosamente',
        'data': {
          'user': {
            'id': user.id,
            'username': user.username,
            'createdAt': user.createdAt
                ?.toIso8601String(), // CORREGIDO: Quitar el ?
          },
          'sessionToken': 'fake_session_${user.id}',
          'loginTime': DateTime.now().toIso8601String(),
        },
      };
    } catch (e) {
      // Simular delay adicional en caso de error
      await Future.delayed(Duration(milliseconds: 500));
      rethrow;
    }
  }

  @override
  Future<bool> logout() async {
    // Simular delay de "llamada a API" para logout
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(500)));

    try {
      // Limpiar SharedPreferences COMPLETAMENTE
      await _clearUserSession();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    // Simular verificación de sesión (más rápida)
    await Future.delayed(Duration(milliseconds: 200 + Random().nextInt(300)));

    final prefs = await SharedPreferences.getInstance();
    final isActive = prefs.getBool(_sessionKey) ?? false;
    final userJson = prefs.getString(_userKey);

    return isActive && userJson != null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // Simular delay de "consulta a API"
    await Future.delayed(Duration(milliseconds: 300 + Random().nextInt(400)));

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      final isActive = prefs.getBool(_sessionKey) ?? false;

      if (!isActive || userJson == null) {
        return null;
      }

      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      // Si hay error leyendo, limpiar sesión
      await _clearUserSession();
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> autoLogin() async {
    // Simular delay de verificación automática
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(500)));

    final isLoggedIn = await this.isLoggedIn();
    if (!isLoggedIn) {
      return null;
    }

    final user = await getCurrentUser();
    if (user == null) {
      return null;
    }

    return {
      'success': true,
      'message': 'Sesión restaurada automáticamente',
      'data': {
        'user': {
          'id': user.id,
          'username': user.username,
          'createdAt': user.createdAt?.toIso8601String(),
        },
        'sessionToken': 'fake_session_${user.id}',
        'autoLogin': true,
        'lastLoginTime': DateTime.now().toIso8601String(),
      },
    };
  }

  @override
  Future<Map<String, dynamic>> getSessionInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'hasUser': prefs.getString(_userKey) != null,
      'isSessionActive': prefs.getBool(_sessionKey) ?? false,
      'lastLogin': prefs.getString('last_login'),
    };
  }

  // Métodos privados para manejo de SharedPreferences
  Future<void> _saveUserSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    // Guardar datos del usuario
    await prefs.setString(_userKey, json.encode(user.toJson()));

    // Marcar sesión como activa
    await prefs.setBool(_sessionKey, true);

    // Guardar timestamp de login para debugging
    await prefs.setString('last_login', DateTime.now().toIso8601String());
  }

  Future<void> _clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();

    // Limpiar TODOS los datos de sesión
    await prefs.remove(_userKey);
    await prefs.setBool(_sessionKey, false);
    await prefs.remove('last_login');

    //Limpiar también las tareas del usuario
    await prefs.remove('user_tasks');
    await prefs.remove('task_counter');
  }
}
