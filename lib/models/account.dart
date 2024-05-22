import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String? userID;
  String? phoneNumber;
  String? firstName;
  String? middleName;
  String? lastName;
  String? sex;
  double? weight;
  String? userType;

  Account({
    this.userID,
    this.phoneNumber,
    this.firstName,
    this.middleName,
    this.lastName,
    this.sex,
    this.weight,
    this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'sex': sex,
      'weight': weight,
      'userType': userType,
    };
  }

  factory Account.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Account(
      userID: snapshot.id,
      phoneNumber: data['phoneNumber'],
      firstName: data['firstName'],
      middleName: data['middleName'],
      lastName: data['lastName'],
      sex: data['sex'],
      weight: data['weight'],
      userType: data['userType'],
    );
  }
}
