import 'package:prueba_tecnica_broers/Models/task_model.dart';

abstract class ITaskService {
  // CRUD básico
  Future<Map<String, dynamic>> getAllTasks();
  Future<Map<String, dynamic>> createTask(TaskModel task);
  Future<Map<String, dynamic>> updateTask(TaskModel task);
  Future<Map<String, dynamic>> deleteTask(String taskId);
  
  // Marcar como completada
  Future<Map<String, dynamic>> toggleTaskCompletion(String taskId);
  
  // Limpiar todas las tareas
  Future<Map<String, dynamic>> clearAllTasks();
}