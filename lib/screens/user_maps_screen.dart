import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserMapsScreen extends StatefulWidget {
  const UserMapsScreen({super.key});

  @override
  State<UserMapsScreen> createState() => _UserMapsScreenState();
}

class _UserMapsScreenState extends State<UserMapsScreen> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  double searchlocationContainerHeight = 228;
  double waitingResponsefromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geolocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> polylineCoordinatesList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  // String userName
  // String userEmail

  bool openNavigationDrawer = true;
  bool activeNearbyDriverKeysloaded = false;

  BitmapDescriptor? activeNearbyIcon;

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kGooglePlex,
              polylines: polylineSet,
              markers: markersSet,
              circles: circlesSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {});

                //LocateUserPosition();
              },
              onCameraMove: (CameraPosition? position) {
                if (pickLocation != position!.target) {
                  setState(() {
                    pickLocation = position.target;
                  });
                }
              },
              onCameraIdle: () {
                //getAddressFromLatLng();
              },
            ),
          ],
        ),
      ),
    );
  }
}

//WIDGETTTTS TEMPLATE

Widget buildPickUpAndDropOffCard(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), spreadRadius: 5, blurRadius: 10)],
        borderRadius: BorderRadius.circular(8)),
    child: TextFormField(
      decoration: const InputDecoration(
        hintText: 'Pick up from?',
        hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        suffixIcon: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(
            Icons.search,
          ),
        ),
        border: InputBorder.none,
      ),
    ),
  );
}
