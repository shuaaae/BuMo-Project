import 'dart:async';
import 'dart:developer';
import 'package:angkas_clone_app/utils/constants/api_keys.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _pUSJRMain = LatLng(10.293617, 123.89755);
  static const LatLng _pUSJRBasak = LatLng(10.29169, 123.86138);
  static const LatLng _pGooglePlex = LatLng(37.422131, -122.084801);
  static const LatLng _pApplePark = LatLng(37.334644, -122.008972);
  LatLng? _currentPos = null;

  Map<PolylineId, Polyline> polylines = {};

  Location _locationController = new Location();

  // Google Map Controller
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then(
          (coordinates) => {generatePolylineFromPoints(coordinates)},
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPos == null
          ? const Center(child: Text('Loading...'))
          : GoogleMap(
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition:
                  CameraPosition(target: _pGooglePlex, zoom: 15),
              markers: {
                Marker(
                  markerId: MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _currentPos!,
                ),
                Marker(
                  markerId: MarkerId("_sourceLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _pGooglePlex,
                ),
                Marker(
                  markerId: MarkerId("_destinationLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _pApplePark,
                ),
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  // Function that changes/positions camera postion
  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);

    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
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
    _locationController.onLocationChanged.listen(
      (LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            _currentPos =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            _cameraToPosition(_currentPos!);
          });
        }
      },
    );
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKeys.googleMaps,
      PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
      PointLatLng(
        _pApplePark.latitude,
        _pApplePark.longitude,
      ),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      });
    } else {
      print(result.errorMessage);
    }

    return polylineCoordinates;
  }

  //
  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blueGrey,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }
}
