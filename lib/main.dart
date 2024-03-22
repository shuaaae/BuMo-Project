import 'package:angkas_clone_app/routes.dart';
import 'package:angkas_clone_app/screens/login_screen.dart';
import 'package:angkas_clone_app/screens/map_screen.dart';
import 'package:angkas_clone_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
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
      initialRoute: '/',
      routes: getApplicationRoutes(),
    );
  }
}
