import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prueba_tecnica_broers/Providers/auth_provider.dart';
import 'package:prueba_tecnica_broers/Service/Auth/Interfaces/auth_interface.dart';

// Estado para consultas asincrónicas
class QueryState<T> {
  final bool isLoading;
  final T? data;
  final String? error;

  const QueryState({this.isLoading = false, this.data, this.error});

  factory QueryState.initial() => QueryState();
  factory QueryState.loading() => QueryState(isLoading: true);
  factory QueryState.success(T data) => QueryState(data: data);
  factory QueryState.error(String message) => QueryState(error: message);

  bool get isInitial => !isLoading && data == null && error == null;
  bool get hasError => error != null;
  bool get hasData => data != null;
}

// Provider para estados de consulta
final queryProvider = StateProvider.family<QueryState<dynamic>, String>(
  (ref, key) => QueryState.initial(),
);

class UseLogin {
  final WidgetRef ref;
  final IAuthService authService;

  UseLogin(this.ref)
    : authService = ref.read(
        authServiceProvider as ProviderListenable<IAuthService>,
      );

  String _getProviderKey(String username) => 'login_$username';

  // Login con solo username
  Future<void> login(String username) async {
    final key = _getProviderKey(username);
    final notifier = ref.read(queryProvider(key).notifier);

    try {
      // Iniciar loading
      notifier.state = QueryState.loading();

      // Llamar al servicio de autenticación
      final response = await authService.login(username);

      // Actualizar estado global
      ref
          .read(authProvider.notifier)
          .login(response['data']['user']['username']);

      // Actualizar estado de consulta
      notifier.state = QueryState.success(response);

      // Notificar éxito
      _showToast("¡Inicio de sesión exitoso!");
    } catch (error) {
      // Manejar error
      notifier.state = QueryState.error(error.toString());

      _showToast("Error: ${error.toString()}");
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    try {
      await authService.logout();
      ref.read(authProvider.notifier).logout();
      _showToast("Sesión cerrada");
    } catch (e) {
      _showToast("Error al cerrar sesión");
    }
  }

  // Obtener estado actual
  QueryState getState(String username) {
    final key = _getProviderKey(username);
    return ref.watch(queryProvider(key));
  }

  // Invalidar estado (útil para logout)
  void invalidate(String username) {
    final key = _getProviderKey(username);
    ref.invalidate(queryProvider(key));
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }
}

// Extension para uso fácil en widgets
extension LoginHookExtension on BuildContext {
  UseLogin get useLogin {
    final ref = ProviderScope.containerOf(this);
    return UseLogin(ref as WidgetRef);
  }
}
