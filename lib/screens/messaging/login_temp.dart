// ignore_for_file: use_build_context_synchronously

import 'package:angkas_clone_app/providers/account_provider.dart';
import 'package:angkas_clone_app/screens/rider-side/rider_maps_screen.dart';
import 'package:angkas_clone_app/screens/driver-side/driver_maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginTemp extends StatefulWidget {
  const LoginTemp({super.key});

  @override
  State<LoginTemp> createState() => _LoginTempState();
}

class _LoginTempState extends State<LoginTemp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void loginUser() async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print("HOYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
      print(_emailController);
      print(_passwordController);

      final String userId = userCredential.user!.uid;
      final String userType = await AccountNotifier().getUserType(userId);

      print(userType);

      if (userType == "driver") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DriverMapsScreen(driverID: userCredential.user!.uid),
            ));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RiderMapsScreen(passengerID: userCredential.user!.uid),
          ),
        );
      }
    } catch (error) {
      print('Login error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in. Please check your credentials.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Temp for Messaging',
          style: TextStyle(fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loginUser,
                  child: const Text('Sign In'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
