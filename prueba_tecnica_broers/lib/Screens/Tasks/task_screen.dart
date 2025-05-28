import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_broers/Models/task_model.dart';
import 'package:prueba_tecnica_broers/Providers/auth_provider.dart';
import 'package:prueba_tecnica_broers/Providers/task_provider.dart';
import 'package:prueba_tecnica_broers/Screens/Tasks/task_styles.dart';
import 'package:prueba_tecnica_broers/Service/Auth/Implementation/i_auth_implementation.dart';
import 'package:prueba_tecnica_broers/Widgets/Tasks/task_card.dart';
import 'package:prueba_tecnica_broers/Widgets/Tasks/task_form_dialog.dart';
import 'package:prueba_tecnica_broers/Hooks/Tasks/use_task.dart';
import 'package:prueba_tecnica_broers/Service/Tasks/Implementation/i_task_implementation.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  UseTask? useTask;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // No inicializar useTask aquí
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Inicializar solo una vez
    if (!_isInitialized) {
      _isInitialized = true;

      // Ahora sí es seguro acceder al ProviderScope
      useTask = UseTask(ProviderScope.containerOf(context));

      // Cargar tareas después de la inicialización
      WidgetsBinding.instance.addPostFrameCallback((_) {
        useTask?.loadTasks();
      });
    }
  }

  void _showTaskDialog({TaskModel? task}) {
    showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
        task: task,
        onSave: (newTask) async {
          if (task != null) {
            await useTask?.updateTask(newTask);
          } else {
            await useTask?.createTask(newTask);
          }
        },
      ),
    );
  }

  void _toggleTaskCompletion(String taskId) {
    useTask?.toggleCompletion(taskId);
  }

  void _deleteTask(String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar esta tarea?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              useTask?.deleteTask(taskId);
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              // Cerrar diálogo PRIMERO
              Navigator.of(dialogContext).pop();

              try {
                // 1. Ejecutar logout del servicio (esto limpia SharedPreferences COMPLETAMENTE)
                final logoutSuccess = await AuthService.logout();

                if (!logoutSuccess) {
                  throw Exception('Error al cerrar sesión en el servidor');
                }

                // Verificar que el widget sigue montado
                if (!mounted) return;

                // 2. Limpiar el provider de auth (resetear estado)
                ref.read(authProvider.notifier).logout();

                // 3. Limpiar todas las tareas del provider local
                ref.read(taskProvider.notifier).clearTasks();

                // 4. Navegar al login eliminando COMPLETAMENTE el stack
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false, // Esto elimina TODAS las rutas anteriores
                );
              } catch (e) {
                // Verificar mounted antes de mostrar error
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al cerrar sesión: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtener estado de las tareas del provider directamente
    final taskState = ref.watch(taskProvider);
    final tasks = taskState.tasks;
    final activeTasks = tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = tasks.where((task) => task.isCompleted).toList();
    final isLoading = taskState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppDimensions.radiusXL),
                bottomRight: Radius.circular(AppDimensions.radiusXL),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  children: [
                    // Title and logout button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mis Tareas', style: AppTextStyles.headerTitle),
                        IconButton(
                          onPressed: _logout,
                          icon: const Icon(
                            Icons.logout,
                            color: AppColors.white,
                            size: AppDimensions.iconL,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.paddingS),

                    // Stats
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${activeTasks.length} pendientes • ${completedTasks.length} completadas',
                        style: AppTextStyles.headerSubtitle.copyWith(
                          color: AppColors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : tasks.isEmpty
                ? _buildEmptyState()
                : _buildTaskList(activeTasks, completedTasks),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        backgroundColor: AppColors.action,
        child: const Icon(
          Icons.add,
          color: AppColors.white,
          size: AppDimensions.iconL,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 48,
                color: AppColors.tertiary,
              ),
            ),

            const SizedBox(height: AppDimensions.paddingL),

            Text(
              'No tienes tareas',
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),

            const SizedBox(height: AppDimensions.paddingS),

            Text(
              '¡Perfecto! Disfruta tu tiempo libre',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(
    List<TaskModel> activeTasks,
    List<TaskModel> completedTasks,
  ) {
    return ListView(
      padding: const EdgeInsets.only(
        top: AppDimensions.paddingL,
        bottom: AppDimensions.paddingXL * 2,
      ),
      children: [
        // Active tasks
        if (activeTasks.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
            child: Text(
              'Pendientes (${activeTasks.length})',
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),
          ),

          const SizedBox(height: AppDimensions.paddingM),

          ...activeTasks.map(
            (task) => TaskCard(
              task: task,
              isOverdue: TaskService.isTaskOverdue(task),
              onEdit: () => _showTaskDialog(task: task),
              onDelete: () => _deleteTask(task.id),
              onToggleComplete: () => _toggleTaskCompletion(task.id),
            ),
          ),
        ],

        // Completed tasks
        if (completedTasks.isNotEmpty) ...[
          if (activeTasks.isNotEmpty)
            const SizedBox(height: AppDimensions.paddingXL),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
            child: Text(
              'Completadas (${completedTasks.length})',
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),
          ),

          const SizedBox(height: AppDimensions.paddingM),

          ...completedTasks.map(
            (task) => TaskCard(
              task: task,
              isOverdue: false, 
              onEdit: () => _showTaskDialog(task: task),
              onDelete: () => _deleteTask(task.id),
              onToggleComplete: () => _toggleTaskCompletion(task.id),
            ),
          ),
        ],
      ],
    );
  }
}
