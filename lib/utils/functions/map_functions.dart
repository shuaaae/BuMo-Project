import 'dart:math';

import 'package:angkas_clone_app/models/booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error("Location services are disabled.");
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("Location permission denied.");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error("Location permissions are permanently denied.");
  }

  return await Geolocator.getCurrentPosition(
      locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.high));
}

Future<List<LatLng>> getPolylinePoints(
    Location pickupLocation, Location destinationLocation) async {
  PolylinePoints polylinePoints = PolylinePoints();

  // Create a PolylineRequest with the required parameters
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

Future<void> moveCameraToLocations(BuildContext context, LatLng pickupLocation,
    LatLng destinationLocation, GoogleMapController myMapController) async {
  LatLngBounds bounds = LatLngBounds(
    southwest: LatLng(
      min(pickupLocation.latitude, destinationLocation.latitude),
      min(pickupLocation.longitude, destinationLocation.longitude),
    ),
    northeast: LatLng(
      max(pickupLocation.latitude, destinationLocation.latitude),
      max(pickupLocation.longitude, destinationLocation.longitude),
    ),
  );

  LatLng center = LatLng(
    (bounds.southwest.latitude + bounds.northeast.latitude) / 2,
    (bounds.southwest.longitude + bounds.northeast.longitude) / 2,
  );

  double zoomLevel = calculateZoomLevel(bounds, MediaQuery.of(context).size);

  myMapController.animateCamera(
    CameraUpdate.newLatLngZoom(center, zoomLevel),
  );
}

double calculateZoomLevel(LatLngBounds bounds, Size screenSize) {
  const double padding = 50.0;

  double angle = bounds.northeast.longitude - bounds.southwest.longitude;
  double width = screenSize.width - padding * 2;

  double zoom = log(width / angle) / log(2);

  return zoom;
}
