import 'package:cloud_firestore/cloud_firestore.dart';

/* ORIGINAL CODE
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
*/

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
