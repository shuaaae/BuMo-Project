import 'package:angkas_clone_app/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:angkas_clone_app/models/booking_complete.dart';
import 'package:angkas_clone_app/providers/booking_provider.dart';
import 'package:angkas_clone_app/utils/widgets/rider-side-widgets/navigation_drawer.dart';
import 'package:angkas_clone_app/utils/widgets/driver-side-widgets/booking_info_widget.dart';
import 'package:angkas_clone_app/utils/functions/map_helpers.dart';
import 'package:angkas_clone_app/utils/functions/map_functions.dart';

// ignore: must_be_immutable
class DriverMapsScreen extends ConsumerWidget {
  final String driverID;
  DriverMapsScreen({super.key, required this.driverID});

  GoogleMapController? myMapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BookComplete passenger = BookComplete(
      dateTime: DateTime.now(),
      destinationLoc: GeoPoint(10.290208027840634, 123.86190172324898),
      driverID: 'driver123',
      initialLoc: GeoPoint(10.29716766666733, 123.89974298092177),
      passengerID: 'passenger456',
      passengerName: 'John Doe',
      pickupLoc: GeoPoint(10.2942925616758, 123.897496665533),
      pickupTime: 123456789,
      rating: 0,
      travelTime: 0,
      fare: 0,
      locationDistance: 45,
      initialLocName: "",
      pickupLocName: "",
      destinationLocName: "",
    );

    Future<void> fetchLocationDistance() async {
      passenger = await BookingNotifier().updateLocationDistance(passenger);
    }

    Future<void> fetchPricing() async {
      passenger = await BookingNotifier().updatePricing(passenger);
    }

    Future<void> fetchAndUpdatePassengerLocation() async {
      passenger = await BookingNotifier().updateLocationNames(passenger);
      fetchLocationDistance();
      fetchPricing();
    }

    return FutureBuilder<void>(
      future: fetchAndUpdatePassengerLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          final initialLoc = Location(
            latitude: passenger.initialLoc.latitude,
            longitude: passenger.initialLoc.longitude,
            name: "Colonade",
          );
          final initialLocLatLng = LatLng(
              passenger.initialLoc.latitude, passenger.initialLoc.longitude);

          final pickupLoc = Location(
            latitude: passenger.pickupLoc.latitude,
            longitude: passenger.pickupLoc.longitude,
            name: "USJR Main",
          );
          final pickupLocLatLng = LatLng(
              passenger.pickupLoc.latitude, passenger.pickupLoc.longitude);

          final additionalPickupLoc1 = Location(
            latitude: passenger.pickupLoc.latitude + 0.001089,
            longitude: passenger.pickupLoc.longitude + 0.0030000778412,
            name: "Pickup Location 2",
          );
          final additionalPickupLoc1LatLng = LatLng(
              additionalPickupLoc1.latitude, additionalPickupLoc1.longitude);

          final additionalPickupLoc2 = Location(
            latitude: passenger.pickupLoc.latitude + 0.002089,
            longitude: passenger.pickupLoc.longitude + 0.0014589771,
            name: "Pickup Location 3",
          );
          final additionalPickupLoc2LatLng = LatLng(
              additionalPickupLoc2.latitude, additionalPickupLoc2.longitude);

          markers = {
            Marker(
              markerId: MarkerId('myCurrentArea'),
              position: initialLocLatLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              infoWindow: InfoWindow(title: 'My Current Area'),
            ),
            Marker(
              markerId: MarkerId('pickup'),
              position: pickupLocLatLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              infoWindow: InfoWindow(title: 'Pickup Location'),
            ),
            Marker(
              markerId: MarkerId('pickup2'),
              position: additionalPickupLoc1LatLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(title: 'Pickup Location 2'),
            ),
            Marker(
              markerId: MarkerId('pickup3'),
              position: additionalPickupLoc2LatLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(title: 'Pickup Location 3'),
            ),
          };

          MapHelpers.getPolylines(initialLoc, pickupLoc).then((polyline) {
            polylines = polyline;
          });

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
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
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return GoogleMap(
                        mapType: MapType.normal,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        markers: markers,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(snapshot.data!.latitude,
                              snapshot.data!.longitude),
                          zoom: 16,
                        ),
                        polylines: polylines,
                        onMapCreated: (GoogleMapController controller) {
                          myMapController = controller;

                          polylines.clear();

                          moveCameraToLocations(context, initialLocLatLng,
                              pickupLocLatLng, controller);
                          _createRoute(initialLoc, pickupLoc);
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                      );
                    }
                  },
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      BookingInfoSheet(
                        serviceType: "Passenger",
                        booking: passenger,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  LatLng geoPointToLatLng(GeoPoint geoPoint) {
    return LatLng(geoPoint.latitude, geoPoint.longitude);
  }

  Future<void> _createRoute(Location start, Location end) async {
    final List<LatLng> polylineCoordinates =
        await MapHelpers.getPolylinePoints(start, end);

    // Print the coordinates for debugging
    for (var coordinate in polylineCoordinates) {
      print("SO MAO NI");
      print('Lat: ${coordinate.latitude}, Lng: ${coordinate.longitude}');
    }

    polylines.add(Polyline(
      polylineId: PolylineId("route"),
      points: polylineCoordinates,
      color: Colors.blue,
      width: 5,
    ));
  }
}
