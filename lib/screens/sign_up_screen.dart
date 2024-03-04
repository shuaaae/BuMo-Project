import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // Title
                Text("Let's create your account", style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 30),

                // Form Text Fields
                Form(
                    child: Column(
                  children: [
                    // First Name
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'First Name', prefixIcon: Icon(Iconsax.user)),
                    ),
                    const SizedBox(height: 14),

                    // Last Name
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Last Name', prefixIcon: Icon(Iconsax.user)),
                    ),
                    const SizedBox(height: 14),

                    // Email
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Iconsax.direct)),
                    ),
                    const SizedBox(height: 14),

                    // Phone Number
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Phone number', prefixIcon: Icon(Iconsax.call)),
                    ), // TextFormField
                    const SizedBox(height: 14),

                    /// Password
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Iconsax.password_check),
                        suffixIcon: Icon(Iconsax.eye_slash),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Sign Up Button
                    SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('Create Account'))),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
