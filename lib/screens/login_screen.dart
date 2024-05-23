import 'package:angkas_clone_app/screens/registration/register_number_screen.dart';
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //1. LOGO
                  Image.asset(
                    'assets/images/Angkas.png',
                  ),

                  const SizedBox(height: 10),

                  //2. HEADER
                  Text('Welcome',
                      style: Theme.of(context).textTheme.headlineMedium),
                  Text('Put some text here',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 30),

              //3. TEXT FIELDS
              Form(
                  child: Column(
                children: [
                  // Email
                  TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                        labelText: 'Email'),
                  ),
                  const SizedBox(height: 15),

                  // Password
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.password_check),
                      labelText: 'Password',
                      suffixIcon: Icon(Iconsax.eye_slash),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Sign In Button
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => MapPage()));
                          },
                          child: const Text('Sign In'))),
                  const SizedBox(height: 10),

                  // Login Button
                  SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const SignUpScreen();
                            }));
                          },
                          child: const Text('Create Account'))),
                  const SizedBox(height: 30),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
