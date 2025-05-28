import 'package:flutter/material.dart';
import 'package:prueba_tecnica_broers/Screens/Auth/login_screen.dart';
import 'package:prueba_tecnica_broers/Screens/Tasks/task_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String tasks = '/tasks';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    tasks: (context) => const TaskListScreen(),
  };
}
