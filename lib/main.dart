// ignore_for_file: unused_import

import 'package:angkas_clone_app/firebase_options.dart';
import 'package:angkas_clone_app/screens/landing_screen.dart';
import 'package:angkas_clone_app/screens/messaging/inbox_screen.dart';
import 'package:angkas_clone_app/screens/messaging/login_temp.dart';
import 'package:angkas_clone_app/screens/rider-side/driver_rating_screen.dart';
import 'package:angkas_clone_app/screens/rider-side/rider_maps_screen.dart';
import 'package:angkas_clone_app/utils/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Angkas Clone App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LoginTemp());
  }
}
