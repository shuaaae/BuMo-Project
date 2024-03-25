import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen(
      {super.key, required this.phoneNumber, required this.verificationID});
  final String? phoneNumber;
  final String? verificationID;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState(
      phoneNumber: phoneNumber, verificationID: verificationID);
}

class _VerificationScreenState extends State<VerificationScreen> {
  _VerificationScreenState(
      {required this.phoneNumber, required this.verificationID});

  final String? phoneNumber;
  final String? verificationID;
  PhoneNumber inputtedNumber = PhoneNumber();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationID!,
                              smsCode: verificationCode);
                      await auth.signInWithCredential(credential);
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
