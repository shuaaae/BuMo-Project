import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String? riderUserId;
  String? driverUserId;
  Location? pickupLocation;
  Location? destinationLocation;
  double? pricing;

  Booking({
    required this.riderUserId,
    required this.driverUserId,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.pricing,
  });

  Map<String, dynamic> toMap() {
    return {
      'riderUserId': riderUserId,
      'driverUserId': driverUserId,
      'pickupLocation': pickupLocation?.toMap(),
      'destinationLocation': destinationLocation?.toMap(),
      'pricing': pricing,
    };
  }

  factory Booking.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Booking(
      riderUserId: data['riderUserId'],
      driverUserId: data['driverUserId'],
      pickupLocation: Location.fromMap(data['pickupLocation']),
      destinationLocation: Location.fromMap(data['destinationLocation']),
      pricing: data['pricing'],
    );
  }
}

class Location {
  double latitude;
  double longitude;
  String name;

  Location({
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      latitude: map['latitude'],
      longitude: map['longitude'],
      name: map['name'],
    );
  }
}
