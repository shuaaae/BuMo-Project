import 'package:angkas_clone_app/screens/rider-side/rider_maps_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:angkas_clone_app/providers/account_provider.dart';
import 'package:angkas_clone_app/screens/registration/rider_details.dart';
import 'package:angkas_clone_app/utils/widgets/build_snack_bar.dart';
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
                      final accountNotifier =
                          ref.read(accountProvider.notifier);

                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationID!,
                              smsCode: verificationCode);
                      await auth.signInWithCredential(credential);

                      final QuerySnapshot result = await FirebaseFirestore
                          .instance
                          .collection('accounts')
                          .where('phoneNumber', isEqualTo: phoneNumber)
                          .limit(1)
                          .get();
                      final List<DocumentSnapshot> documents = result.docs;

                      if (documents.isNotEmpty) {
                        final DocumentSnapshot document = documents.first;
                        final data = document.data() as Map<String, dynamic>;

                        accountNotifier.updateAccount(
                            emailID: data['emailID'] ?? '',
                            phoneNumber: data['phoneNumber'] ?? phoneNumber,
                            firstName: data['firstName'] ?? '',
                            middleName: data['middleName'],
                            lastName: data['lastName'] ?? '',
                            sex: data['sex'] ?? '',
                            weight: data['weight'] ?? 0.0,
                            userType: data['userType'] ?? '');

                        ScaffoldMessenger.of(context).showSnackBar(
                            buildSnackBar(
                                "Logging in to Existing User.", true, context));

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RiderMapsScreen(
                                      passengerID: '',
                                    )));
                        return;
                      }

                      accountNotifier.updateAccount(
                        phoneNumber: phoneNumber,
                        firstName: '',
                        middleName: null,
                        lastName: '',
                        sex: '',
                        weight: 0.0,
                        userType: '',
                      );

                      showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (context) {
                            return CustomSelectionDialog(onSelection: (role) {
                              if (role == "passenger") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RiderDetailsScreen(
                                                phoneNumber: phoneNumber!)));
                              } else if (role == "driver") {}
                            });
                          });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
                          "Something went wrong with Verifying the OTP.",
                          false,
                          context));
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
