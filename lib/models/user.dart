import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String phoneNumber;
  String firstName;
  String? middleName;
  String lastName;
  String sex;
  double weight;
  String userType;

  User(
      {required this.phoneNumber,
      required this.firstName,
      this.middleName,
      required this.lastName,
      required this.sex,
      required this.weight,
      required this.userType});

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'sex': sex,
      'weight': weight,
      'userType': userType,
    };
  }

  factory User.fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return User(
        phoneNumber: data['phoneNumber'],
        firstName: data['firstName'],
        middleName: data['middleName'],
        lastName: data['lastName'],
        sex: data['sex'],
        weight: data['weight'],
        userType: data['userType']);
  }
}
