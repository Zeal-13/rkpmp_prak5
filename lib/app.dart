import 'package:flutter/material.dart';
import 'package:flutter5/shared/app_theme.dart';
import 'package:flutter5/features/tasks/state/tasks_container.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Management App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const TasksContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}
