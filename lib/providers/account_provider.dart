import 'package:angkas_clone_app/models/account.dart';
import 'package:angkas_clone_app/models/driver_account.dart';
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

  Future<String?> registerAccount() async {
    try {
      final DocumentReference accountRef =
          await _firestore.collection('accounts').add({
        'phoneNumber': state.phoneNumber,
        'firstName': state.firstName,
        'middleName': state.middleName,
        'lastName': state.lastName,
        'sex': state.sex,
        'weight': state.weight,
        'userType': state.userType
      });

      final String accountID = accountRef.id;

      return accountID;
    } catch (e) {
      return null;
    }
  }
}

class DriverAccountNotifier extends StateNotifier<DriverAccount> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DriverAccountNotifier()
      : super(DriverAccount(
            userID: '',
            drivingLicenseNumber: '',
            licensePlate: '',
            modelName: '',
            modelColor: ''));

  void updateDriverAccount(
      {String? userID,
      String? drivingLicenseNumber,
      String? licensePlate,
      String? modelName,
      String? modelColor}) {
    state = DriverAccount(
        userID: userID,
        drivingLicenseNumber: drivingLicenseNumber,
        licensePlate: licensePlate,
        modelName: modelName,
        modelColor: modelColor);
  }

  Future<void> registerDriverAccount(String accountID) async {
    try {
      await _firestore.collection('drivers').add({
        'userID': accountID,
        'drivingLicenseNumber': state.drivingLicenseNumber,
        'vehicle': {
          'licensePlate': state.licensePlate,
          'vehicleModel': {
            'modelName': state.modelName,
            'modelColor': state.modelColor
          },
        },
      });
    } catch (e) {
      print(e);
    }
  }
}
