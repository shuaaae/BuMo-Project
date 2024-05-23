import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String? emailID;
  String? firstName;
  String? lastName;
  String? middleName;
  String? password;
  String? phoneNumber;
  String? sex;
  String? userID;
  String? userType;
  double? weight;

  Account({
    this.emailID,
    this.firstName,
    this.lastName,
    this.middleName,
    this.password,
    this.phoneNumber,
    this.sex,
    this.userID,
    this.userType,
    this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'emailID': emailID,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'password': password,
      'phoneNumber': phoneNumber,
      'sex': sex,
      'userID': userID,
      'userType': userType,
      'weight': weight,
    };
  }

  factory Account.fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Account(
      emailID: data['emailID'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      middleName: data['middleName'],
      password: data['password'],
      phoneNumber: data['phoneNumber'],
      sex: data['sex'],
      userID: data['userID'],
      userType: data['userType'],
      weight: (data['weight'] as num?)?.toDouble(),
    );
  }
}
