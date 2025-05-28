// lib/Service/Tasks/Implementation/fake_task_repository.dart
import 'dart:convert';
import 'dart:math';
import 'package:prueba_tecnica_broers/Service/Tasks/Interfaces/task_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/task_model.dart';

class FakeTaskRepository implements ITaskService {
  static const String _tasksKey = 'user_tasks';
  static const String _taskCounterKey = 'task_counter';
  
  // Para desarrollo rápido - cambiar a true para desactivar delays
  static const bool _isDevelopment = false;

  // Simular delay de red variable
  Future<void> _simulateNetworkDelay({int minMs = 100, int maxMs = 300}) async {
    if (_isDevelopment) return;
    final delay = minMs + Random().nextInt(maxMs - minMs);
    await Future.delayed(Duration(milliseconds: delay));
  }

  // Simular ocasionales errores de red (1% probabilidad)
  void _simulateNetworkError() {
    if (_isDevelopment) return;
    if (Random().nextInt(100) == 0) {
      throw Exception('Error de conexión: No se pudo conectar con el servidor');
    }
  }

  // Helper method para obtener tareas sin delay
  Future<List<TaskModel>> _getTasksFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString(_tasksKey);
    
    if (tasksJson == null) return [];
    
    final tasksList = json.decode(tasksJson) as List;
    return tasksList.map((taskJson) => TaskModel.fromJson(taskJson)).toList();
  }

  // Helper method para guardar tareas
  Future<void> _saveTasksToStorage(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString(_tasksKey, tasksJson);
  }

  // Helper para generar ID único
  Future<String> _generateTaskId() async {
    final prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt(_taskCounterKey) ?? 1;
    await prefs.setInt(_taskCounterKey, counter + 1);
    return counter.toString();
  }

  @override
  Future<Map<String, dynamic>> getAllTasks() async {
    await _simulateNetworkDelay();
    _simulateNetworkError();

    try {
      final tasks = await _getTasksFromStorage();
      return {
        'success': true,
        'data': tasks.map((task) => task.toJson()).toList(),
        'message': 'Tareas obtenidas exitosamente',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'message': 'Error interno del servidor: $e',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> createTask(TaskModel task) async {
    await _simulateNetworkDelay(minMs: 200, maxMs: 500);
    _simulateNetworkError();

    try {
      final tasks = await _getTasksFromStorage();
      final newTask = task.copyWith(
        id: await _generateTaskId(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      tasks.add(newTask);
      await _saveTasksToStorage(tasks);

      return {
        'success': true,
        'data': newTask.toJson(),
        'message': 'Tarea creada exitosamente',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'message': 'Error al crear la tarea: $e',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updateTask(TaskModel updatedTask) async {
    await _simulateNetworkDelay(minMs: 150, maxMs: 400);
    _simulateNetworkError();

    try {
      final tasks = await _getTasksFromStorage();
      final index = tasks.indexWhere((task) => task.id == updatedTask.id);
      
      if (index == -1) {
        return {
          'success': false,
          'data': null,
          'message': 'Tarea no encontrada',
          'timestamp': DateTime.now().toIso8601String(),
        };
      }

      tasks[index] = updatedTask.copyWith(updatedAt: DateTime.now());
      await _saveTasksToStorage(tasks);

      return {
        'success': true,
        'data': tasks[index].toJson(),
        'message': 'Tarea actualizada exitosamente',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'message': 'Error al actualizar la tarea: $e',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> toggleTaskCompletion(String taskId) async {
    await _simulateNetworkDelay(minMs: 100, maxMs: 250);
    _simulateNetworkError();

    try {
      final tasks = await _getTasksFromStorage();
      final index = tasks.indexWhere((task) => task.id == taskId);
      
      if (index == -1) {
        return {
          'success': false,
          'data': null,
          'message': 'Tarea no encontrada',
          'timestamp': DateTime.now().toIso8601String(),
        };
      }

      final task = tasks[index];
      tasks[index] = task.copyWith(
        isCompleted: !task.isCompleted,
        updatedAt: DateTime.now(),
      );
      await _saveTasksToStorage(tasks);

      return {
        'success': true,
        'data': tasks[index].toJson(),
        'message': 'Estado de tarea actualizado exitosamente',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'message': 'Error al cambiar estado de la tarea: $e',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> deleteTask(String taskId) async {
    await _simulateNetworkDelay(minMs: 150, maxMs: 300);
    _simulateNetworkError();

    try {
      final tasks = await _getTasksFromStorage();
      final initialLength = tasks.length;
      tasks.removeWhere((task) => task.id == taskId);
      
      if (tasks.length == initialLength) {
        return {
          'success': false,
          'data': null,
          'message': 'Tarea no encontrada',
          'timestamp': DateTime.now().toIso8601String(),
        };
      }

      await _saveTasksToStorage(tasks);

      return {
        'success': true,
        'data': null,
        'message': 'Tarea eliminada exitosamente',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'message': 'Error al eliminar la tarea: $e',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> clearAllTasks() async {
    await _simulateNetworkDelay(minMs: 200, maxMs: 400);
    _simulateNetworkError();
    
    try {
      await _saveTasksToStorage([]);
      return {
        'success': true,
        'data': null,
        'message': 'Todas las tareas eliminadas exitosamente',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'message': 'Error al eliminar todas las tareas: $e',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }
}