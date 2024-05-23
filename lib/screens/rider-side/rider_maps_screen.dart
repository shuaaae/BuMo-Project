import 'package:angkas_clone_app/models/booking.dart';
import 'package:angkas_clone_app/providers/booking_provider.dart';
import 'package:angkas_clone_app/screens/map-utils/map_functions.dart';
import 'package:angkas_clone_app/screens/rider-side/location_search_screen.dart';
import 'package:angkas_clone_app/utils/constants/api_keys.dart';
import 'package:angkas_clone_app/utils/widgets/custom_selection_widget.dart';
import 'package:angkas_clone_app/utils/widgets/rider-widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class RiderMapsScreen extends ConsumerWidget {
  GoogleMapController? myMapController;
  bool isSettingSource = true;
  LatLng? sourceLocation;
  LatLng? destination;
  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};

  final calculatedFare = 100.00;
  final serviceType = 'Passenger';
  final duration = '2-10 min(s)';

  RiderMapsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final pickupName = bookingState?.pickupLocation?.name;
    final destinationName = bookingState?.destinationLocation?.name;

    final pickupController = TextEditingController(text: pickupName);
    final destinationController = TextEditingController(text: destinationName);
    final pickupLocation = bookingState?.pickupLocation;
    final destinationLocation = bookingState?.destinationLocation;

    Future<List<LatLng>> getPolylinePoints(
        Location pickupLocation, Location destinationLocation) async {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        APIKeys.googleMaps,
        PointLatLng(pickupLocation.latitude, pickupLocation.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude),
      );

      List<LatLng> polylineCoordinates = [];
      if (result.points.isNotEmpty) {
        polylineCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
      }
      return polylineCoordinates;
    }

    markers.clear();

    if (pickupLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: LatLng(pickupLocation.latitude, pickupLocation.longitude),
          infoWindow: InfoWindow(title: 'Pickup'),
        ),
      );
    }

    if (destinationLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: LatLng(
              destinationLocation.latitude, destinationLocation.longitude),
          infoWindow: InfoWindow(title: 'Destination'),
        ),
      );
    }

    if (pickupLocation != null && destinationLocation != null) {
      getPolylinePoints(pickupLocation, destinationLocation).then((polyline) {
        if (polyline.isNotEmpty) {
          polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: polyline,
              color: Colors.blue,
              width: 6,
            ),
          );
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      drawer: const CustomNavigationDrawer(),
      body: Stack(
        children: [
          FutureBuilder(
            future: determinePosition(),
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
                    target: LatLng(
                        snapshot.data!.latitude, snapshot.data!.longitude),
                    zoom: 16,
                  ),
                  polylines: polylines,
                  onMapCreated: (GoogleMapController controller) {
                    myMapController = controller;
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  // onTap: _onMapTapped,
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
                          Position position = await determinePosition();

                          myMapController?.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                    position.latitude, position.longitude),
                                zoom: 16,
                              ),
                            ),
                          );
                        },
                        child: PhysicalModel(
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
                ),
                const SizedBox(height: 5),
                Container(
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LocationSearchScreen()));
                        },
                        child: Column(
                          children: [
                            AbsorbPointer(
                              child: TextFormField(
                                controller: pickupController,
                                style: Theme.of(context).textTheme.bodySmall,
                                readOnly: true,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: 'Pick up from?',
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  prefixIcon: Icon(
                                    Icons.adjust,
                                    color: Colors.blue,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            AbsorbPointer(
                              child: TextFormField(
                                controller: destinationController,
                                readOnly: true,
                                maxLines: null,
                                style: Theme.of(context).textTheme.bodySmall,
                                decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: 'Drop off to?',
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    color: Color.fromARGB(255, 255, 102, 0),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
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
                ),
                const SizedBox(height: 10),
                Container(
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
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  size: 12),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
