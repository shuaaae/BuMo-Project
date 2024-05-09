import 'package:angkas_clone_app/utils/theme/app_bar_theme.dart';
import 'package:angkas_clone_app/utils/theme/elevated_button_theme.dart';
import 'package:angkas_clone_app/utils/theme/outlined_button_theme.dart';
import 'package:angkas_clone_app/utils/theme/text_field_theme.dart';
import 'package:angkas_clone_app/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      primaryColor: const Color.fromARGB(255, 14, 174, 229),
      scaffoldBackgroundColor: Colors.white,
      textTheme: AppTextTheme.lightTextTheme,
      elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
      appBarTheme: MyAppBarTheme.lightAppBarTheme,
      outlinedButtonTheme: AppOutlinedButtonTheme.lightOutlinedButtonTheme,
      inputDecorationTheme: AppTextFormFieldTheme.lightInputDecorationTheme,
      colorScheme: const ColorScheme.light().copyWith(
          primary: Color.fromARGB(255, 223, 245, 253),
          background: const Color.fromARGB(255, 227, 238, 246),
          error: const Color.fromARGB(255, 248, 222, 220)));

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: AppTextTheme.darkTextTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: MyAppBarTheme.darkAppBarTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: AppTextFormFieldTheme.darkInputDecorationTheme,
  );
}
