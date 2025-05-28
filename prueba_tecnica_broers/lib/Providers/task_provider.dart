import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_broers/Models/task_model.dart';
import 'package:prueba_tecnica_broers/Service/Tasks/Implementation/i_task_implementation.dart';

class TaskState {
  final List<TaskModel> tasks;
  final bool isLoading;

  TaskState({required this.tasks, required this.isLoading});

  // Estado inicial
  factory TaskState.initial() {
    return TaskState(tasks: [], isLoading: false);
  }
}

class TaskNotifier extends StateNotifier<TaskState> {
  TaskNotifier() : super(TaskState.initial());

  // Solo cambia el estado - no hace llamadas a servicios
  void setTasks(List<TaskModel> tasks) {
    state = TaskState(tasks: tasks, isLoading: false);
  }

  void setLoading(bool loading) {
    state = TaskState(tasks: state.tasks, isLoading: loading);
  }

  void addTask(TaskModel task) {
    state = TaskState(tasks: [...state.tasks, task], isLoading: false);
  }

  void updateTask(TaskModel updatedTask) {
    final updatedTasks = state.tasks.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();

    state = TaskState(tasks: updatedTasks, isLoading: state.isLoading);
  }

  void removeTask(String taskId) {
    final updatedTasks = state.tasks
        .where((task) => task.id != taskId)
        .toList();

    state = TaskState(tasks: updatedTasks, isLoading: state.isLoading);
  }

  void clearTasks() {
    state = TaskState(tasks: [], isLoading: false);
  }
}

// Provider de estado para las tareas
final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier();
});

// Provider que expone el servicio de tareas
final taskServiceProvider = Provider<TaskService>((ref) {
  return TaskService();
});
