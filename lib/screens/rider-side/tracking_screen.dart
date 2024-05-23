import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:angkas_clone_app/utils/functions/map_functions.dart';
import 'package:angkas_clone_app/models/booking.dart'; // Make sure to import your Location model

class TrackingScreen extends StatefulWidget {
  final LatLng destination;
  final Set<Marker> initialMarkers;
  final Set<Polyline> initialPolylines;

  const TrackingScreen({
    Key? key,
    required this.destination,
    required this.initialMarkers,
    required this.initialPolylines,
  }) : super(key: key);

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _hasArrived = false; // New variable to track if the user has arrived

  @override
  void initState() {
    super.initState();

    _markers = widget.initialMarkers
        .where((marker) => marker.markerId.value != 'pickup')
        .toSet();
    _polylines = widget.initialPolylines;
    _getCurrentLocation();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _markers.add(Marker(
        markerId: MarkerId('currentPosition'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarker,
      ));
      _updatePolyline();
      _checkIfArrived();
    });
  }

  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings:
          LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
        _markers.removeWhere(
            (marker) => marker.markerId.value == 'currentPosition');
        _markers.add(Marker(
          markerId: MarkerId('currentPosition'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });

      _updatePolyline();
      _moveCameraToCurrentPosition();
      _checkIfArrived();
    });
  }

  void _updatePolyline() async {
    if (_currentPosition != null && !_hasArrived) {
      List<LatLng> polylineCoordinates = await getPolylinePoints(
        Location(
            name: 'Current Position',
            latitude: _currentPosition!.latitude,
            longitude: _currentPosition!.longitude),
        Location(
            name: 'Destination',
            latitude: widget.destination.latitude,
            longitude: widget.destination.longitude),
      );

      setState(() {
        _polylines.clear();
        if (polylineCoordinates.isNotEmpty) {
          _polylines.add(Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            width: 6,
            points: polylineCoordinates,
          ));
        }
      });
    }
  }

  Future<void> _moveCameraToCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;
    if (_currentPosition != null && !_hasArrived) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  void _checkIfArrived() {
    if (_currentPosition != null && !_hasArrived) {
      double distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        widget.destination.latitude,
        widget.destination.longitude,
      );

      if (distance < 50) {
        setState(() {
          _hasArrived = true;
        });
        _showArrivalDialog();
      }
    }
  }

  void _showArrivalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Arrived!'),
        content: Text('You have arrived at your destination.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.destination,
            zoom: 15.0,
          ),
          markers: _markers,
          polylines: _polylines,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
      ]),
      extendBodyBehindAppBar: true,
    );
  }
}
