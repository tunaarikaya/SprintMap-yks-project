import 'package:flutter/material.dart';
import 'package:sprintmap/theme/app_theme.dart';
import 'package:sprintmap/mainwrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SprintMap App',
      theme: AppTheme.lightTheme,
      home: const MainWrapper(),
    );
  }
}
