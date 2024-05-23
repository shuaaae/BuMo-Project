import 'package:angkas_clone_app/models/booking.dart';
import 'package:angkas_clone_app/utils/constants/api_keys.dart';
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
      desiredAccuracy: LocationAccuracy.high);
}

Future<List<LatLng>> getPolylinePoints(
    Location pickupLocation, Location destinationLocation) async {
  PolylinePoints polylinePoints = PolylinePoints();
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    APIKeys.googleMaps,
    PointLatLng(pickupLocation.latitude, pickupLocation.longitude),
    PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
  );

  List<LatLng> polylineCoordinates = [];
  if (result.points.isNotEmpty) {
    polylineCoordinates = result.points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }
  return polylineCoordinates;
}
