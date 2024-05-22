import 'package:cloud_firestore/cloud_firestore.dart';

class RiderAccount {
  String? userID;

  RiderAccount({this.userID});

  factory RiderAccount.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return RiderAccount(
      userID: data['userID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
    };
  }

  factory RiderAccount.fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return RiderAccount(userID: data['userID']);
  }
}
