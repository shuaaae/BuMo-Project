import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  String? driverID;
  bool? isProbation;
  double? totalRating;
  int? totalRides;
  List<RideLog>? rideLogs;

  Transaction({
    this.driverID,
    this.isProbation,
    this.totalRating,
    this.totalRides,
    this.rideLogs,
  });

  Map<String, dynamic> toMap() {
    return {
      'isProbation': isProbation,
      'totalRating': totalRating,
      'totalRides': totalRides,
      // Ride logs are not included in the top-level map because they're a sub-collection
    };
  }

  factory Transaction.fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Transaction(
      driverID: snapshot.id,
      isProbation: data['isProbation'],
      totalRating: (data['totalRating'] as num?)?.toDouble(),
      totalRides: data['totalRides'],
    );
  }
}

class RideLog {
  String? rideLogID;
  Timestamp? dateTime;
  GeoPoint? destinationLoc;
  GeoPoint? initialLoc;
  String? passengerID;
  GeoPoint? pickupLoc;
  int? pickupTime;
  double? rating;
  int? travelTime;

  RideLog({
    this.rideLogID,
    this.dateTime,
    this.destinationLoc,
    this.initialLoc,
    this.passengerID,
    this.pickupLoc,
    this.pickupTime,
    this.rating,
    this.travelTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'destinationLoc': destinationLoc,
      'initialLoc': initialLoc,
      'passengerID': passengerID,
      'pickupLoc': pickupLoc,
      'pickupTime': pickupTime,
      'rating': rating,
      'travelTime': travelTime,
    };
  }

  factory RideLog.fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return RideLog(
      rideLogID: snapshot.id,
      dateTime: data['dateTime'],
      destinationLoc: data['destinationLoc'],
      initialLoc: data['initialLoc'],
      passengerID: data['passengerID'],
      pickupLoc: data['pickupLoc'],
      pickupTime: data['pickupTime'],
      rating: (data['rating'] as num?)?.toDouble(),
      travelTime: data['travelTime'],
    );
  }
}
