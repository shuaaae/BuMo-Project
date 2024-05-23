import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  String? driverID;
  String? drivingLicenseNumber;
  String? licensePlate;
  String? modelColor;
  String? modelName;
  String? userID;

  Vehicle({
    this.driverID,
    this.drivingLicenseNumber,
    this.licensePlate,
    this.modelColor,
    this.modelName,
    this.userID,
  });

  Map<String, dynamic> toMap() {
    return {
      'driverID': driverID,
      'drivingLicenseNumber': drivingLicenseNumber,
      'licensePlate': licensePlate,
      'modelColor': modelColor,
      'modelName': modelName,
      'userID': userID,
    };
  }

  factory Vehicle.fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Vehicle(
      driverID: data['driverID'],
      drivingLicenseNumber: data['drivingLicenseNumber'],
      licensePlate: data['licensePlate'],
      modelColor: data['modelColor'],
      modelName: data['modelName'],
      userID: data['userID'],
    );
  }
}
