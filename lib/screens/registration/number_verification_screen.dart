import 'package:angkas_clone_app/providers/account_provider.dart';
import 'package:angkas_clone_app/screens/registration/passenger_details.dart';
import 'package:angkas_clone_app/utils/widgets/custom_selection_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:angkas_clone_app/models/account.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

final accountProvider =
    StateNotifierProvider<AccountNotifier, Account>((ref) => AccountNotifier());

class VerificationScreen extends ConsumerWidget {
  const VerificationScreen(
      {super.key, required this.phoneNumber, required this.verificationID});
  final String? phoneNumber;
  final String? verificationID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text("Enter the verification PIN sent to",
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 5),
                Text(phoneNumber!,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 10),
                OtpTextField(
                  numberOfFields: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  onSubmit: (String verificationCode) async {
                    try {
                      final accountNotifer = ref.read(accountProvider.notifier);

                      // PhoneAuthCredential credential =
                      //     PhoneAuthProvider.credential(
                      //         verificationId: verificationID!,
                      //         smsCode: verificationCode);
                      // await auth.signInWithCredential(credential);

                      accountNotifer.updateAccount(
                        phoneNumber: phoneNumber,
                        firstName: '',
                        middleName: null,
                        lastName: '',
                        sex: '',
                        weight: 0.0,
                        userType: '',
                      );

                      showDialog(
                          context: context,
                          builder: (context) {
                            return CustomSelectionDialog(onSelection: (role) {
                              if (role == "passenger") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PassengerDetailsScreen(
                                                phoneNumber: phoneNumber!)));
                              } else if (role == "driver") {}
                            });
                          });
                    } catch (e) {
                      print("Wrong Pin.");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(25)),
        child: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
