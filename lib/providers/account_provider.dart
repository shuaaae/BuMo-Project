import 'package:angkas_clone_app/models/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountNotifier extends StateNotifier<Account> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AccountNotifier()
      : super(
          Account(
            phoneNumber: '',
            firstName: '',
            middleName: null,
            lastName: '',
            sex: '',
            weight: 0.0,
            userType: '',
          ),
        );

  void updateAccount(
      {String? phoneNumber,
      String? firstName,
      String? middleName,
      String? lastName,
      String? sex,
      double? weight,
      String? userType}) {
    state = Account(
        phoneNumber: phoneNumber,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        sex: sex,
        weight: weight,
        userType: userType);
  }

  Future<void> registerAccount() async {
    try {
      await _firestore.collection('accounts').add({
        'phoneNumber': state.phoneNumber,
        'firstName': state.firstName,
        'middleName': state.middleName,
        'lastName': state.lastName,
        'sex': state.sex,
        'weight': state.weight,
        'userType': state.userType
      });
    } catch (e) {
      print(e);
    }
  }
}
