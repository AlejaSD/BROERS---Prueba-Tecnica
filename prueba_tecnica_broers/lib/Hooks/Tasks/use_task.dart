import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_broers/Providers/task_provider.dart';
import 'package:prueba_tecnica_broers/Service/Tasks/Implementation/i_task_implementation.dart';
import 'package:prueba_tecnica_broers/Models/task_model.dart';

class UseTask {
  final ProviderContainer container;

  UseTask(this.container);

  Future<void> loadTasks() async {
    container.read(taskProvider.notifier).setLoading(true);
    try {
      final tasks = await TaskService.getAllTasks();
      container.read(taskProvider.notifier).setTasks(tasks);
    } finally {
      container.read(taskProvider.notifier).setLoading(false);
    }
  }

  Future<void> createTask(TaskModel task) async {
    await TaskService.addTask(task);
    await loadTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await TaskService.updateTask(task);
    await loadTasks();
  }

  Future<void> toggleCompletion(String taskId) async {
    await TaskService.toggleTaskCompletion(taskId);
    await loadTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await TaskService.deleteTask(taskId);
    await loadTasks();
  }
}
