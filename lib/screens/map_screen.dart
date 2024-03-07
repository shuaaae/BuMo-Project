import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  //Nice muhimo ug private variables si Hussain Mustafa kay _p iya gamiton

  static const LatLng _pCebuCity = LatLng(10.31672, 123.89071);

  // Rider Position:
  static const LatLng _pUSJRMain = LatLng(10.293617, 123.89755);
  // Driver Position:
  static const LatLng _pUSJRBasak = LatLng(10.29169, 123.86138);

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
}
