import 'dart:async';
import 'package:angkas_clone_app/screens/rider-side/driver_rating_screen.dart';
import 'package:angkas_clone_app/utils/constants/box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:angkas_clone_app/utils/functions/map_functions.dart';
import 'package:angkas_clone_app/models/booking.dart';

class TrackingScreen extends StatefulWidget {
  final LatLng destination;
  final Set<Marker> initialMarkers;
  final Set<Polyline> initialPolylines;

  const TrackingScreen({
    super.key,
    required this.destination,
    required this.initialMarkers,
    required this.initialPolylines,
  });

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _hasArrived = false;

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
        markerId: const MarkerId('currentPosition'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarker,
      ));
      _updatePolyline();
      _checkIfArrived();
    });
  }

  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
        _markers.removeWhere(
            (marker) => marker.markerId.value == 'currentPosition');
        _markers.add(Marker(
          markerId: const MarkerId('currentPosition'),
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
            polylineId: const PolylineId('route'),
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DriverRatingScreen()));
      }
    }
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
        Positioned(
            bottom: 0,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 0, bottom: 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [kBoxShadow],
                                borderRadius: BorderRadius.circular(25)),
                            child: const Center(child: Text("Safety Guide")),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Position position = await determinePosition();
                              final GoogleMapController controller =
                                  await _controller.future;

                              controller.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                        position.latitude, position.longitude),
                                    zoom: 16,
                                  ),
                                ),
                              );
                            },
                            child: const PhysicalModel(
                              color: Colors.black,
                              elevation: 10.0,
                              shape: BoxShape.circle,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.my_location,
                                    color: Color.fromARGB(255, 25, 90, 158)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 0, right: 0, left: 0),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        child: Center(
                            child: Text(
                          "In transit tayo. Don't use your phone!",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white),
                        )),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [kBoxShadow],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/helmet.png',
                              height: 30,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Passenger >",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      Text("P56.00",
                          style: Theme.of(context).textTheme.bodyLarge)
                    ],
                  ),
                )
              ],
            ))
      ]),
      extendBodyBehindAppBar: true,
    );
  }
}
