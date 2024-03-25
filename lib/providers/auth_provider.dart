import 'package:angkas_clone_app/screens/login_screen.dart';
import 'package:angkas_clone_app/screens/map_screen.dart';
import 'package:angkas_clone_app/screens/on-boarding_screen.dart';
import 'package:angkas_clone_app/screens/register_number_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateChangesProvider = StreamProvider((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

class AuthWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    return authState.when(
        data: (user) {
          if (user != null) {
            return MapPage();
          } else {
            return OnBoarding();
          }
        },
        loading: () => CircularProgressIndicator(),
        error: (error, stackTrace) => Text('Error: $error'));
  }
}
