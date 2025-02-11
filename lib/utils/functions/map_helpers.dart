// map_helpers.dart
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:angkas_clone_app/models/booking.dart';

class MapHelpers {
  static Future<List<LatLng>> getPolylinePoints(
/*************  ✨ Codeium Command ⭐  *************/
      /// Returns the coordinates of the shortest driving route from [pickupLocation] to [destinationLocation]
      ///
      /// The [TravelMode] used is [TravelMode.driving], but this can be changed to other modes such as
      /// [TravelMode.walking] or [TravelMode.bicycling].
      ///
      /// If the route cannot be found, an empty list is returned.
/******  9ded828c-9dce-42ee-9254-5c6079492cd7  *******/
      Location pickupLocation,
      Location destinationLocation) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineRequest request = PolylineRequest(
      origin: PointLatLng(pickupLocation.latitude, pickupLocation.longitude),
      destination: PointLatLng(
          destinationLocation.latitude, destinationLocation.longitude),
      mode: TravelMode
          .driving, // Specify the travel mode (e.g., driving, walking, bicycling)
    );

    // Pass the request to getRouteBetweenCoordinates
    PolylineResult result =
        await polylinePoints.getRouteBetweenCoordinates(request: request);

    List<LatLng> polylineCoordinates = [];
    if (result.points.isNotEmpty) {
      polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    }
    return polylineCoordinates;
  }

  static Set<Marker> getMarkers(
      Location? pickupLocation, Location? destinationLocation) {
    Set<Marker> markers = {};

    if (pickupLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: LatLng(pickupLocation.latitude, pickupLocation.longitude),
          infoWindow: const InfoWindow(title: 'Pickup'),
        ),
      );
    }

    if (destinationLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(
              destinationLocation.latitude, destinationLocation.longitude),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      );
    }

    return markers;
  }

  static Future<Set<Polyline>> getPolylines(
      Location? pickupLocation, Location? destinationLocation) async {
    Set<Polyline> polylines = {};

    if (pickupLocation != null && destinationLocation != null) {
      List<LatLng> polylinePoints =
          await getPolylinePoints(pickupLocation, destinationLocation);
      if (polylinePoints.isNotEmpty) {
        polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: polylinePoints,
            color: Colors.blue,
            width: 6,
          ),
        );
      }
    }

    return polylines;
  }
}
