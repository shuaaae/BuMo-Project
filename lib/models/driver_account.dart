import 'package:cloud_firestore/cloud_firestore.dart';

class DriverAccount {
  String? userID;
  String? drivingLicenseNumber;
  String? licensePlate;
  String? modelName;
  String? modelColor;

  DriverAccount({
    this.userID,
    this.drivingLicenseNumber,
    this.licensePlate,
    this.modelName,
    this.modelColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'drivingLicenseNumber': drivingLicenseNumber,
      'vehicle': {
        'licensePlate': licensePlate,
        'vehicleModel': {'modelName': modelName, 'modelColor': modelColor}
      }
    };
  }

  factory DriverAccount.fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    Map<String, dynamic> vehicleData = ['vehicle'] as Map<String, dynamic>;
    Map<String, dynamic> vechileModelData =
        vehicleData['vehicleModel'] as Map<String, dynamic>;

    return DriverAccount(
        userID: data['userID'],
        drivingLicenseNumber: data['drivingLicenseNumber'],
        licensePlate: vehicleData['licensePlate'],
        modelName: vechileModelData['modelName'],
        modelColor: vechileModelData['modelColor']);
  }
}
