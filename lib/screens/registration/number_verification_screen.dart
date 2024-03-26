import 'package:angkas_clone_app/providers/account_provider.dart';
import 'package:angkas_clone_app/screens/registration/passenger_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:angkas_clone_app/models/account.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

final accountProvider =
    StateNotifierProvider<AccountNotifier, Account>((ref) => AccountNotifier());

class VerificationScreen extends ConsumerWidget {
  const VerificationScreen(
      {super.key, required this.phoneNumber, required this.verificationID});
  final String? phoneNumber;
  final String? verificationID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? phoneNumber;
    String? verificationID;
    PhoneNumber inputtedNumber = PhoneNumber();

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
                      final accountNotifer =
                          ProviderContainer().read(accountProvider.notifier);

                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationID!,
                              smsCode: verificationCode);
                      await auth.signInWithCredential(credential);

                      accountNotifer.updateUser(
                        phoneNumber: phoneNumber,
                        firstName: '',
                        middleName: null,
                        lastName: '',
                        sex: '',
                        weight: 0.0,
                        userType: '',
                      );

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PassengerDetailsScreen(
                                  phoneNumber: phoneNumber)));
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
    );
  }
}
