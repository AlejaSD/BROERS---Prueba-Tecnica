import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_broers/Service/Auth/Implementation/i_auth_implementation.dart';

class AuthState {
  final bool isLoggedIn;
  final String username;

  AuthState({required this.isLoggedIn, required this.username});

  factory AuthState.initial() {
    return AuthState(isLoggedIn: false, username: '');
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  // Solo cambia el estado - no hace llamadas a servicios
  void login(String username) {
    state = AuthState(isLoggedIn: true, username: username);
  }

  void logout() {
    state = AuthState.initial();
  }

  void clearSession() {
    state = AuthState.initial();
  }
}

// Provider de estado
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Provider que expone el servicio (sin lógica)
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(); // Solo expone el servicio
});
