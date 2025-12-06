import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/app_theme.dart';
import 'features/app/presentation/pages/app_container.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Movie Management App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const AppContainer(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
