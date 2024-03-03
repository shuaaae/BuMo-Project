import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 14, right: 14),
          child: Column(
            children: [
              Column(
                children: [
                  //1. LOGO
                  const Placeholder(fallbackHeight: 150),

                  //2. HEADER
                  Text('Welcome', style: Theme.of(context).textTheme.headlineMedium),
                  Text('Put some text here', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),

              //3. TEXT FIELDS
              Form(
                  child: Column(
                children: [
                  // Email
                  TextFormField(
                    decoration: const InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: 'Email'),
                  ),
                  const SizedBox(height: 30),

                  // Password
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.password_check),
                      labelText: 'Password',
                      suffixIcon: Icon(Iconsax.eye_slash),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Sign In Button
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('Sign In'))),
                  // Login Button
                  SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () {}, child: const Text('Login'))),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
