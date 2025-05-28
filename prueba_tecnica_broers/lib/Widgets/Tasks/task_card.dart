import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prueba_tecnica_broers/Models/task_model.dart';
import 'package:prueba_tecnica_broers/Screens/Tasks/task_styles.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final bool isOverdue; // Recibe como parámetro
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleComplete;

  const TaskCard({
    super.key,
    required this.task,
    required this.isOverdue, // Obligatorio
    this.onEdit,
    this.onDelete,
    this.onToggleComplete,
  });

  Color _getPriorityColor() {
    switch (task.priority) {
      case Priority.high:
        return AppColors.priorityHigh;
      case Priority.medium:
        return AppColors.priorityMedium;
      case Priority.low:
        return AppColors.priorityLow;
    }
  }

  String _getPriorityLabel() {
    switch (task.priority) {
      case Priority.high:
        return 'Alta';
      case Priority.medium:
        return 'Media';
      case Priority.low:
        return 'Baja';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cambiar a localización por defecto (inglés)
    final dateFormat = DateFormat('d MMM');

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      elevation: AppDimensions.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      color: AppColors.white,
      child: Opacity(
        opacity: task.isCompleted ? 0.75 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              GestureDetector(
                onTap: onToggleComplete,
                child: Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isCompleted
                          ? AppColors.action
                          : AppColors.grey300,
                      width: 2,
                    ),
                    color: task.isCompleted
                        ? AppColors.action
                        : Colors.transparent,
                  ),
                  child: task.isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: AppColors.white,
                        )
                      : null,
                ),
              ),

              const SizedBox(width: AppDimensions.paddingM),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Priority
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isCompleted
                                  ? AppColors.textMuted
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),

                        // Priority indicator
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getPriorityColor(),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getPriorityLabel(),
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ),

                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: AppDimensions.paddingS),
                      Text(
                        task.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? AppColors.textMuted
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],

                    const SizedBox(height: AppDimensions.paddingM),

                    // Date and Actions
                    Row(
                      children: [
                        // Date
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: AppDimensions.iconS,
                              color: isOverdue
                                  ? AppColors.error
                                  : AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dateFormat.format(task.dueDate),
                              style: AppTextStyles.caption.copyWith(
                                color: isOverdue
                                    ? AppColors.error
                                    : AppColors.textMuted,
                                fontWeight: isOverdue
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            if (isOverdue) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.warning,
                                size: 12,
                                color: AppColors.error,
                              ),
                            ],
                          ],
                        ),

                        const Spacer(),

                        // Action buttons
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit),
                              iconSize: AppDimensions.iconS,
                              color: AppColors.textMuted,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                            IconButton(
                              onPressed: onDelete,
                              icon: const Icon(Icons.delete),
                              iconSize: AppDimensions.iconS,
                              color: AppColors.textMuted,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
