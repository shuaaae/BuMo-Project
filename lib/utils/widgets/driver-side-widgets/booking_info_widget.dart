import 'package:flutter/material.dart';
import 'package:angkas_clone_app/models/booking_complete.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingInfoSheet extends StatelessWidget {
  final String serviceType;
  final BookComplete booking;

  const BookingInfoSheet({
    super.key,
    required this.serviceType,
    required this.booking,
  });

  String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  // ignore: unused_element
  void _proceedTransaction(BookComplete booking) {
    FirebaseFirestore.instance
        .collection('transaction')
        .doc(booking.driverID)
        .set({
      'isHide': true,
      'isProbation': false,
      'totalRating': 0,
      'totalRides': 0,
    }).then((_) {
      FirebaseFirestore.instance
          .collection('transaction')
          .doc(booking.driverID)
          .collection('bookings')
          .add({
        'dateTime': booking.dateTime,
        'destinationLoc': booking.destinationLoc,
        'driverID': booking.driverID,
        'fare': booking.fare,
        'initialLoc': booking.initialLoc,
        'locationDistance': booking.locationDistance,
        'passengerID': booking.passengerID,
        'passengerName': booking.passengerName,
        'pickupLoc': booking.pickupLoc,
        'pickupTime': booking.pickupTime,
        'rating': booking.rating,
        'travelTime': booking.travelTime,
      });
    }).catchError((error) {
      print("Failed to add transaction: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 10,
          )
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/helmet.png',
                      height: 20,
                    ),
                    Text(
                      '  $serviceType  ',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                  ],
                ),
                Text(formatTime(booking.dateTime)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.passengerName,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Pickup Location: ${booking.pickupLocName}",
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Destination Location: ${booking.destinationLocName}",
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the start
                    children: [
                      Text(
                          "Distance: ${booking.locationDistance.toStringAsFixed(2)} km"),
                      Text("Price: Php ${booking.fare}"),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Accept Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
