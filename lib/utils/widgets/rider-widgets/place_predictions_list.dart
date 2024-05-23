import 'dart:convert';

import 'package:angkas_clone_app/components/network_utils.dart';
import 'package:angkas_clone_app/models/booking.dart';
import 'package:angkas_clone_app/providers/booking_provider.dart';
import 'package:angkas_clone_app/screens/rider-side/location_search_screen.dart';
import 'package:angkas_clone_app/utils/constants/api_keys.dart';
import 'package:angkas_clone_app/utils/widgets/location_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacePredictionsList extends ConsumerWidget {
  PlacePredictionsList({
    Key? key,
    required this.pickupController,
    required this.destinationController,
  }) : super(key: key);

  final TextEditingController pickupController;
  final TextEditingController destinationController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placePredictions = ref.watch(placePredictionsProvider);
    final isPickupFocused = ref.watch(focusedFieldProvider);

    return Expanded(
      child: ListView.builder(
        itemCount: placePredictions.length,
        itemBuilder: (context, index) => LocationListTile(
          location: placePredictions[index].description!,
          press: () async {
            String placeId = placePredictions[index].placeId!;
            Map<String, dynamic>? placeDetails =
                await fetchPlaceDetails(placeId);

            final bookingNotifier = ref.read(bookingProvider);

            if (placeDetails != null) {
              String address = placeDetails['formatted_address'];
              double latitude = placeDetails['geometry']['location']['lat'];
              double longitude = placeDetails['geometry']['location']['lng'];

              final location = Location(
                  latitude: latitude, longitude: longitude, name: address);

              final bookingNotifier = ref.watch(bookingProvider.notifier);

              if (isPickupFocused) {
                pickupController.text = address;
                bookingNotifier.updatePickupLocation(location);
              } else {
                destinationController.text = address;
                bookingNotifier.updateDestinationLocation(location);
              }
            }
          },
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>?> fetchPlaceDetails(String placeId) async {
  Uri uri = Uri.https(
    "maps.googleapis.com",
    'maps/api/place/details/json',
    {
      "place_id": placeId,
      "key": APIKeys.googleMaps,
    },
  );

  String? response = await NetworkUtils.fetchUrl(uri);
  if (response != null) {
    Map<String, dynamic> result = json.decode(response);
    if (result['status'] == 'OK') {
      return result['result'];
    }
  }
  return null;
}
