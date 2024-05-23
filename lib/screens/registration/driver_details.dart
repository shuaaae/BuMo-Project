import 'package:angkas_clone_app/models/driver_account.dart';
import 'package:angkas_clone_app/providers/account_provider.dart';
import 'package:angkas_clone_app/screens/registration/number_verification_screen.dart';
import 'package:angkas_clone_app/utils/widgets/build_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final driverAccountProvider =
    StateNotifierProvider<DriverAccountNotifier, DriverAccount>(
        (ref) => DriverAccountNotifier());

class DriverDetailsScreen extends ConsumerWidget {
  const DriverDetailsScreen({super.key, required this.phoneNumber});
  final String phoneNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController firstNameController = TextEditingController(),
        middleNameController = TextEditingController(),
        lastNameController = TextEditingController(),
        drivingLicenseNumberController = TextEditingController(),
        licensePlateController = TextEditingController(),
        modelNameController = TextEditingController(),
        modelColorController = TextEditingController();

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
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: drivingLicenseNumberController,
                    decoration: const InputDecoration(
                        labelText: 'Driving License Number',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: licensePlateController,
                    decoration: const InputDecoration(
                        labelText: 'Vehicle License Plate',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: modelNameController,
                    decoration: const InputDecoration(
                        labelText: 'Model Name',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: modelColorController,
                    decoration: const InputDecoration(
                        labelText: 'Model Color',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 55,
          width: 110,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(25)),
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Next",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        onTap: () async {
          try {
            final accountNotifer = ref.watch(accountProvider.notifier);
            final driverAccountNotifier =
                ref.watch(driverAccountProvider.notifier);

            accountNotifer.updateAccount(
                phoneNumber: phoneNumber,
                firstName: firstNameController.text,
                middleName: middleNameController.text.isEmpty
                    ? null
                    : middleNameController.text,
                lastName: lastNameController.text,
                sex: null,
                weight: null,
                userType: 'driver');

            driverAccountNotifier.updateDriverAccount(
                drivingLicenseNumber: drivingLicenseNumberController.text,
                licensePlate: licensePlateController.text,
                modelName: modelNameController.text,
                modelColor: modelColorController.text);

            String? accountID = await accountNotifer.registerAccount();
            driverAccountNotifier.registerDriverAccount(accountID!);

            ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
                "Driver Account Successfully created.", true, context));

            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const MapPage()));
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
                "Something went wrong with Creating the Account.",
                false,
                context));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
