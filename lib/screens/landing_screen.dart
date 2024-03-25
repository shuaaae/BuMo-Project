import 'package:angkas_clone_app/providers/auth_provider.dart';
import 'package:angkas_clone_app/utils/effects/fade_page_route.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(FadePageRoute(page: AuthCheck()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/Angkas.png',
          scale: 20,
        ),
      ),
    );
  }
}
