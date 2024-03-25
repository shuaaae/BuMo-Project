import 'package:angkas_clone_app/firebase_options.dart';
import 'package:angkas_clone_app/providers/auth_provider.dart';
import 'package:angkas_clone_app/screens/landing_screen.dart';
import 'package:angkas_clone_app/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
          title: 'Angkas Clone App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: LandingScreen()),
    );
  }
}
