import 'package:angkas_clone_app/models/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountNotifier extends StateNotifier<Account> {
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

  void updateUser(
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
}
