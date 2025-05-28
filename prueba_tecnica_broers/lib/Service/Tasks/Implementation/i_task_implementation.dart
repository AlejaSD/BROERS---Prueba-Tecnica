// lib/Service/Tasks/Implementation/i_task_implementation.dart
import 'package:prueba_tecnica_broers/Models/task_model.dart';
import 'package:prueba_tecnica_broers/Service/Tasks/Implementation/fake_task_repository.dart';

class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  // Instancia del repositorio que simula la API
  final FakeTaskRepository _repository = FakeTaskRepository();

  // Obtener todas las tareas
  static Future<List<TaskModel>> getAllTasks() async {
    final service = TaskService();
    final response = await service._repository.getAllTasks();
    
    if (response['success'] == true) {
      final List<dynamic> tasksData = response['data'] ?? [];
      return tasksData.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Error al obtener las tareas');
    }
  }

  // Obtener tareas activas
  static Future<List<TaskModel>> getActiveTasks() async {
    final allTasks = await getAllTasks();
    return allTasks.where((task) => !task.isCompleted).toList();
  }

  // Obtener tareas completadas
  static Future<List<TaskModel>> getCompletedTasks() async {
    final allTasks = await getAllTasks();
    return allTasks.where((task) => task.isCompleted).toList();
  }

  // Agregar nueva tarea
  static Future<TaskModel> addTask(TaskModel task) async {
    final service = TaskService();
    final response = await service._repository.createTask(task);
    
    if (response['success'] == true) {
      return TaskModel.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Error al crear la tarea');
    }
  }

  // Actualizar tarea existente
  static Future<TaskModel> updateTask(TaskModel task) async {
    final service = TaskService();
    final response = await service._repository.updateTask(task);
    
    if (response['success'] == true) {
      return TaskModel.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Error al actualizar la tarea');
    }
  }

  // Eliminar tarea
  static Future<void> deleteTask(String taskId) async {
    final service = TaskService();
    final response = await service._repository.deleteTask(taskId);
    
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Error al eliminar la tarea');
    }
  }

  // Alternar estado de completado
  static Future<TaskModel> toggleTaskCompletion(String taskId) async {
    final service = TaskService();
    final response = await service._repository.toggleTaskCompletion(taskId);
    
    if (response['success'] == true) {
      return TaskModel.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Error al cambiar estado de la tarea');
    }
  }

  // Limpiar todas las tareas
  static Future<void> clearAllTasks() async {
    final service = TaskService();
    final response = await service._repository.clearAllTasks();
    
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Error al limpiar las tareas');
    }
  }

  // Verificar si una tarea está vencida
  static bool isTaskOverdue(TaskModel task) {
    return !task.isCompleted && task.dueDate.isBefore(DateTime.now());
  }

  // Obtener tareas por prioridad
  static Future<List<TaskModel>> getTasksByPriority(Priority priority) async {
    final allTasks = await getAllTasks();
    return allTasks.where((task) => task.priority == priority).toList();
  }

  // Obtener tareas vencidas
  static Future<List<TaskModel>> getOverdueTasks() async {
    final allTasks = await getAllTasks();
    return allTasks.where((task) => isTaskOverdue(task)).toList();
  }
}