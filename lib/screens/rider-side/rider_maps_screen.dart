import 'package:angkas_clone_app/screens/map-utils/location_search_screen.dart';
import 'package:angkas_clone_app/utils/constants/api_keys.dart';
import 'package:angkas_clone_app/utils/widgets/custom_selection_widget.dart';
import 'package:angkas_clone_app/utils/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class RiderMapsScreen extends StatefulWidget {
  const RiderMapsScreen({super.key});

  @override
  State<RiderMapsScreen> createState() => _RiderMapsScreenState();
}

class _RiderMapsScreenState extends State<RiderMapsScreen> {
  GoogleMapController? myMapController;
  bool isSettingSource = true;
  LatLng? sourceLocation;
  LatLng? destination;
  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    getPolylinePoints();
  }

  Future<Position> _determinePosition() async {
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

  void getPolylinePoints() async {
    if (sourceLocation == null || destination == null) return;

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKeys.googleMaps,
      PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
      PointLatLng(destination!.latitude, destination!.longitude),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {});
    }
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      if (isSettingSource) {
        sourceLocation = position;
        markers.add(
            Marker(markerId: const MarkerId('source'), position: position));
      } else {
        destination = position;
        markers.add(Marker(
            markerId: const MarkerId('destination'), position: position));
        getPolylinePoints();
      }
      isSettingSource = !isSettingSource;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _determinePosition(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return GoogleMap(
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  markers: markers,
                  initialCameraPosition: CameraPosition(
                    target: snapshot.data == null
                        ? LatLng(37.422131, -122.084801)
                        : LatLng(
                            snapshot.data!.latitude, snapshot.data!.longitude),
                    zoom: 13,
                  ),
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId("route"),
                      points: polylineCoordinates,
                      color: Colors.blue,
                      width: 6,
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    myMapController = controller;
                  },
                  onTap: _onMapTapped,
                );
              }
            },
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 5,
                              blurRadius: 10,
                            )
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('REMINDERS',
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Position position = await _determinePosition();

                          myMapController?.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                    position.latitude, position.longitude),
                                zoom: 14,
                              ),
                            ),
                          );

                          markers.add(
                            Marker(
                              markerId: const MarkerId('currentLocation'),
                              position:
                                  LatLng(position.latitude, position.longitude),
                            ),
                          );
                          setState(() {});
                        },
                        child: buildCurrentLocationIcon(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                buildPickUpAndDropOffCard(context),
                const SizedBox(height: 10),
                buildBottomSheet(context),
              ],
            ),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      drawer: const CustomNavigationDrawer(),
    );
  }
}

Widget buildCurrentLocationIcon() {
  return const PhysicalModel(
    color: Colors.black,
    elevation: 10.0,
    shape: BoxShape.circle,
    child: CircleAvatar(
      radius: 18,
      backgroundColor: Colors.white,
      child: Icon(Icons.my_location, color: Color.fromARGB(255, 25, 90, 158)),
    ),
  );
}

Widget buildPickUpAndDropOffCard(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * .95,
    height: 150,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          spreadRadius: 5,
          blurRadius: 10,
        )
      ],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LocationSearchScreen(),
              ),
            );
          },
          child: Container(
            height: 45,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: AbsorbPointer(
              child: TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Pick up from?',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.adjust,
                    color: Colors.blue,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 45,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              hintText: 'Drop off to?',
              hintStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              prefixIcon: Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 255, 102, 0),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomSelectionWidget(
                image: 'assets/images/helmet.png',
                text: ' Cash',
              ),
              Container(
                height: 15.0,
                width: 2.0,
                color: const Color.fromARGB(77, 29, 28, 28),
                padding: const EdgeInsets.only(right: 3.0),
              ),
              const CustomSelectionWidget(
                image: 'assets/images/helmet.png',
                text: ' Promo',
              ),
              Container(
                height: 15.0,
                width: 2.0,
                color: const Color.fromARGB(77, 29, 28, 28),
                padding: const EdgeInsets.only(right: 3.0),
              ),
              const CustomSelectionWidget(
                image: 'assets/images/helmet.png',
                text: ' Notes',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildBottomSheet(BuildContext context) {
  final calculatedFare = 100.00;
  final serviceType = 'Passenger';
  final duration = '2-10 min(s)';

  return Container(
    padding: const EdgeInsets.fromLTRB(15, 16, 15, 20),
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          spreadRadius: 5,
          blurRadius: 10,
        )
      ],
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(25),
        topLeft: Radius.circular(25),
      ),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/helmet.png',
                  height: 20,
                ),
                Text(
                  '  $serviceType  ',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 12),
              ],
            ),
            Text(duration),
            Text(
              'P $calculatedFare',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Book'),
          ),
        ),
      ],
    ),
  );
}
