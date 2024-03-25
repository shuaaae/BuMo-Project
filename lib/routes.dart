import 'package:angkas_clone_app/providers/auth_provider.dart';
import 'package:angkas_clone_app/screens/login_screen.dart';
import 'package:angkas_clone_app/screens/map_screen.dart';
import 'package:angkas_clone_app/screens/on-boarding_screen.dart';
import 'package:angkas_clone_app/screens/register_number_screen.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return {
    '/': (context) => AuthWidget(),
    '/login_page': (context) => LoginScreen(),
    '/sign_up_page': (context) => SignUpScreen(),
    '/rider_map_screen': (context) => MapPage()
  };
}
