import 'package:angkas_clone_app/providers/booking_provider.dart';
import 'package:angkas_clone_app/utils/functions/map_helpers.dart';
import 'package:angkas_clone_app/utils/widgets/rider-side-widgets/navigation_drawer.dart';
import 'package:angkas_clone_app/utils/widgets/rider-side-widgets/rider-map-widgets/booking_details_widget.dart';
import 'package:angkas_clone_app/utils/widgets/rider-side-widgets/rider-map-widgets/booking_sheet_widget.dart';
import 'package:angkas_clone_app/utils/widgets/rider-side-widgets/rider-map-widgets/reminders_and_current_location.dart';
import 'package:angkas_clone_app/utils/functions/map_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RiderMapsScreen extends ConsumerWidget {
  final String passengerID;
  RiderMapsScreen({super.key, required this.passengerID});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final pickupName = bookingState?.pickupLocation?.name;
    final destinationName = bookingState?.destinationLocation?.name;

    final pickupController = TextEditingController(text: pickupName);
    final destinationController = TextEditingController(text: destinationName);
    final pickupLocation = bookingState?.pickupLocation;
    final destinationLocation = bookingState?.destinationLocation;

    markers = MapHelpers.getMarkers(pickupLocation, destinationLocation);

    if (pickupLocation != null && destinationLocation != null) {
      MapHelpers.getPolylines(pickupLocation, destinationLocation)
          .then((polyline) {
        polylines = polyline;
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
                    target: LatLng(
                        snapshot.data!.latitude, snapshot.data!.longitude),
                    zoom: 16,
                  ),
                  polylines: polylines,
                  onMapCreated: (GoogleMapController controller) {
                    myMapController = controller;

                    polylines.clear();

                    if (pickupLocation != null && destinationLocation != null) {
                      moveCameraToLocations(
                          context,
                          LatLng(pickupLocation.latitude,
                              pickupLocation.longitude),
                          LatLng(destinationLocation.latitude,
                              destinationLocation.longitude),
                          controller);
                    }
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
                RemindersAndCurrentLocation(myMapController: myMapController),
                const SizedBox(height: 5),
                BookingDetailsWidget(
                    pickupController: pickupController,
                    destinationController: destinationController),
                const SizedBox(height: 10),
                BookingSheetWidget(
                  serviceType: serviceType,
                  duration: duration,
                  calculatedFare: calculatedFare,
                  isButtonEnabled:
                      pickupLocation != null && destinationLocation != null,
                  markers: markers,
                  polylines: polylines,
                  destination: destinationLocation,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
