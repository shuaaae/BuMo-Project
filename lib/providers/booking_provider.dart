import 'package:angkas_clone_app/models/booking.dart';
import 'package:angkas_clone_app/models/booking_complete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:angkas_clone_app/utils/functions/name_coordinates.dart';
import 'dart:math';

class BookingNotifier extends StateNotifier<Booking?> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BookingNotifier() : super(null);

  void updateBooking(
      {String? riderUserId,
      String? driverUserId,
      Location? pickupLocation,
      Location? destinationLocation,
      double? pricing}) {
    state = Booking(
      riderUserId: riderUserId,
      driverUserId: driverUserId,
      pickupLocation: pickupLocation,
      destinationLocation: destinationLocation,
      pricing: pricing,
    );
  }

  void updatePickupLocation(Location pickupLocation) {
    state = Booking(
      riderUserId: state?.riderUserId,
      driverUserId: state?.driverUserId,
      pickupLocation: pickupLocation,
      destinationLocation: state?.destinationLocation,
      pricing: state?.pricing,
    );
  }

  void updateDestinationLocation(Location destinationLocation) {
    state = Booking(
      riderUserId: state?.riderUserId,
      driverUserId: state?.driverUserId,
      pickupLocation: state?.pickupLocation,
      destinationLocation: destinationLocation,
      pricing: state?.pricing,
    );
  }

  Future<String?> saveBooking() async {
    try {
      if (state != null) {
        final DocumentReference bookingRef =
            await _firestore.collection('bookings').add(state!.toMap());
        final String bookingID = bookingRef.id;
        return bookingID;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> getBookingCompleteDetails() async {
    try {
      if (state != null) {
        final DocumentReference bookingRef =
            await _firestore.collection('booking').add(state!.toMap());
        final String bookingID = bookingRef.id;
        return bookingID;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<BookComplete> updateLocationNames(BookComplete passenger) async {
    double initialLocLatitude = passenger.initialLoc.latitude ?? 0.0;
    double initialLocLongitude = passenger.initialLoc.longitude ?? 0.0;
    double pickupLocLatitude = passenger.pickupLoc.latitude ?? 0.0;
    double pickupLocLongitude = passenger.pickupLoc.longitude ?? 0.0;
    double destinationLocLatitude = passenger.destinationLoc.latitude ?? 0.0;
    double destinationLocLongitude = passenger.destinationLoc.longitude ?? 0.0;

    passenger.initialLocName =
        await getLocationName(initialLocLatitude, initialLocLongitude) ??
            "Unknown";

    passenger.pickupLocName =
        await getLocationName(pickupLocLatitude, pickupLocLongitude) ??
            "Unknown";

    passenger.destinationLocName = await getLocationName(
            destinationLocLatitude, destinationLocLongitude) ??
        "Unknown";

    // Return the updated passenger object
    print(
        "HEY TESTTTTTTTTTTTTTTTTTTTTTTTIIIIIIIIIIIIIIIIIIIINGGGGGGGGGGGGGGGGGGG");
    print(('BookComplete(dateTime: ${passenger.dateTime}, destinationLoc: ${passenger.destinationLoc}, '
        'driverID: ${passenger.driverID}, initialLoc: ${passenger.initialLoc}, passengerID: ${passenger.passengerID}, '
        'passengerName: ${passenger.passengerName}, pickupLoc: ${passenger.pickupLoc}, pickupTime: ${passenger.pickupTime}, '
        'rating: ${passenger.rating}, travelTime: ${passenger.travelTime}, fare: ${passenger.fare}, '
        'locationDistance: ${passenger.locationDistance}, initialLocName: ${passenger.initialLocName}, '
        'pickupLocName: ${passenger.pickupLocName}, destinationLocName: ${passenger.destinationLocName})'));
    return passenger;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3; // Earth's radius in meters
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final deltaPhi = (lat2 - lat1) * pi / 180;
    final deltaLambda = (lon2 - lon1) * pi / 180;

    final a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distance in meters
  }

  Future<BookComplete> updateLocationDistance(BookComplete booking) async {
    final pickupLoc = booking.pickupLoc;
    final destinationLoc = booking.destinationLoc;

    final distance = calculateDistance(
      destinationLoc.latitude,
      destinationLoc.longitude,
      pickupLoc.latitude,
      pickupLoc.longitude,
    );
    booking.locationDistance =
        double.parse((distance / 1000).toStringAsFixed(2));
    // if (state != null) {
    //   state = state.copyWith(
    //       locationDistance: distance / 1000); // Convert to km if needed
    // }
    return booking;
  }

  Future<BookComplete> updatePricing(BookComplete booking) async {
    booking.fare = booking.locationDistance * 25;
    return booking;
  }
}

final bookingProvider = StateNotifierProvider<BookingNotifier, Booking?>((ref) {
  return BookingNotifier();
});
