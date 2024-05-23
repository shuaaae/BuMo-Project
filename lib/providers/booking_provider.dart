import 'package:angkas_clone_app/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

final bookingProvider = StateNotifierProvider<BookingNotifier, Booking?>((ref) {
  return BookingNotifier();
});
