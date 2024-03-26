import 'package:angkas_clone_app/screens/map_screen.dart';
import 'package:angkas_clone_app/screens/registration/register_number_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class PassengerDetailsScreen extends ConsumerWidget {
  const PassengerDetailsScreen({super.key, required this.phoneNumber});
  final String phoneNumber;

  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController firstNameController = TextEditingController(),
        middleNameController = TextEditingController(),
        lastNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What's your name?",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text("Your full name will help everyone in identifying you.",
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: middleNameController,
                    decoration: const InputDecoration(
                        labelText: 'Middle Name (Optional)',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
