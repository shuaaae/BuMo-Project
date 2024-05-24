import 'package:cloud_firestore/cloud_firestore.dart';

class BookComplete {
  DateTime dateTime;
  GeoPoint destinationLoc;
  String driverID;
  GeoPoint initialLoc;
  String passengerID;
  String passengerName;
  GeoPoint pickupLoc;
  int pickupTime;
  double rating;
  int travelTime;
  double fare;
  double locationDistance;
  String initialLocName;
  String pickupLocName;
  String destinationLocName;

  BookComplete({
    required this.dateTime,
    required this.destinationLoc,
    required this.driverID,
    required this.initialLoc,
    required this.passengerID,
    required this.passengerName,
    required this.pickupLoc,
    required this.pickupTime,
    required this.rating,
    required this.travelTime,
    required this.fare,
    required this.locationDistance,
    required this.initialLocName,
    required this.pickupLocName,
    required this.destinationLocName,
  });

  // Method to convert a Firestore document snapshot to a BookComplete object
  factory BookComplete.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return BookComplete(
      dateTime: data['dateTime'],
      destinationLoc: data['destinationLoc'],
      driverID: data['driverID'],
      initialLoc: data['initialLoc'],
      passengerID: data['passengerID'],
      passengerName: data['passengerName'],
      pickupLoc: data['pickupLoc'],
      pickupTime: data['pickupTime'],
      rating: (data['rating'] as num).toDouble(),
      fare: data['fare'],
      travelTime: data['travelTime'],
      locationDistance: (data['locationDistance'] as num).toDouble(),
      initialLocName: data['initialLocName'],
      pickupLocName: data['pickupLocName'],
      destinationLocName: data['destinationLocName'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'dateTime': dateTime,
      'destinationLoc': destinationLoc,
      'driverID': driverID,
      'initialLoc': initialLoc,
      'passengerID': passengerID,
      'passengerName': passengerName,
      'pickupLoc': pickupLoc,
      'pickupTime': pickupTime,
      'rating': rating,
      'fare': fare,
      'travelTime': travelTime,
      'locationDistance': locationDistance,
      'initialLocName': initialLocName,
      'pickupLocName': pickupLocName,
      'destinationLocName': destinationLocName,
    };
  }
}
