import 'dart:math';

import 'package:angkas_clone_app/providers/auth_provider.dart';
import 'package:angkas_clone_app/screens/registration/number_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  PhoneNumber number = PhoneNumber(isoCode: 'PH');
  String initialCountry = 'PH';
  final TextEditingController controller = TextEditingController();

  PhoneNumber inputtedNumber = PhoneNumber();

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
                Text("Enter your mobile number",
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 10),

                // Form Text Fields
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sign Up Button
                    InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        inputtedNumber = number;
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        useBottomSheetSafeArea: true,
                      ),
                      hintText: null,
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: controller,
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: IntrinsicWidth(
          child: Row(
            children: [
              const Text(
                'We\'re sending you a verification PIN to your mobile \nnumber. We use your number to allow bikers \nand customer service to contact you about bookings.',
                style: TextStyle(fontSize: 10, color: Colors.grey),
                softWrap: true,
              ),
              const SizedBox(
                width: 30,
              ),
              InkWell(
                child: Container(
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
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: inputtedNumber.phoneNumber,
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerificationScreen(
                                    verificationID: verificationId,
                                    phoneNumber: inputtedNumber.phoneNumber)));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  } catch (error) {
                    print(error);
                  }
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
