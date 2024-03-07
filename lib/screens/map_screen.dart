import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  //Nice muhimo ug private variables si Hussain Mustafa kay _p iya gamiton
  static const LatLng _pCebuCity = LatLng(10.31672, 123.89071);
  static const LatLng _pUSJRMain = LatLng(10.293617, 123.89755);
  static const LatLng _pUSJRBasak = LatLng(10.29169, 123.86138);

  LatLng? _currentPos = null;

  Location _locationController = new Location();

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _pUSJRMain, zoom: 13),
        markers: {
          Marker(
            markerId: MarkerId("_currentLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pUSJRMain,
          ),
          Marker(
            markerId: MarkerId("_sourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pUSJRBasak,
          )
        },
      ),
    );
  }

  Future<void> getLocationUpdates() async {
    //flag variable that tells us if we are allowed to get the users location or not:
    bool _serviceEnabled;
    // stores the PermissionStatus -> the value that determines whether we are allowed permission by the user
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      print(_serviceEnabled.toString());
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        print(PermissionStatus.granted.toString());
        return;
      }
    }

    //tracks frequent location changes in user
    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentPos = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });

        print(currentLocation);
      }
    });
  }
}
