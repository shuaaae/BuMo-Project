import 'package:angkas_clone_app/screens/landing_screen.dart';
import 'package:angkas_clone_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Angkas Clone App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: LandingScreen(),
    );
  }
}
