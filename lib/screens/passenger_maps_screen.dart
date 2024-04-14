import 'package:angkas_clone_app/screens/location_search_screen.dart';
import 'package:angkas_clone_app/widgets/custom_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PassengerMapsScreen extends StatefulWidget {
  const PassengerMapsScreen({super.key});

  @override
  State<PassengerMapsScreen> createState() => _PassengerMapsScreenState();
}

class _PassengerMapsScreenState extends State<PassengerMapsScreen> {
  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GoogleMapController? myMapController;
  Set<Marker> markers = {};

  /*void placeAutocomplate(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        'maps/api/place/autocomplete/json', // unencoder path
        {
          "input": query, // query parameter
          "key": APIKeys.googleMaps, // make sure you add your api key
        });
    // its time to make the GET request

    String? response = await RequestAssistant.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result = PlaceAutocompleteResponse.parse
    }
  }*/
  Future<Position> _determinePosition() async {
    LocationPermission permission;

    final hasPermission = await Permission.locationWhenInUse.serviceStatus.isEnabled;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: false,
            markers: markers,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              myMapController = controller;
            },
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), spreadRadius: 5, blurRadius: 10)],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('REMINDERS', style: Theme.of(context).textTheme.bodySmall),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Position position = await _determinePosition();

                        myMapController?.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));

                        markers.clear();

                        markers.add(Marker(markerId: const MarkerId('currentLocation'), position: LatLng(position.latitude, position.longitude)));

                        setState(() {});
                      },
                      child: buildCurrentLocationIcon(),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                buildPickUpAndDropOffCard(context),
                const SizedBox(height: 10),
                buildBottomSheet(context),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget buildCurrentLocationIcon() {
  return PhysicalModel(
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), spreadRadius: 5, blurRadius: 10)],
        borderRadius: BorderRadius.circular(16)),
    child: Column(
      children: [
        const SizedBox(height: 10),
        Container(
          height: 45,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocationSearchScreen()),
              );
            },
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Pick up from?',
                hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                prefixIcon: Icon(
                  Icons.adjust,
                  color: Colors.blue,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 45,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Drop off to?',
              hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
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
              CustomSelectionWidget(image: 'assets/images/helmet.png', text: ' Cash'),
              Container(
                height: 15.0,
                width: 2.0,
                color: const Color.fromARGB(77, 29, 28, 28),
                padding: const EdgeInsets.only(right: 3.0),
              ),
              CustomSelectionWidget(image: 'assets/images/helmet.png', text: ' Promo'),
              Container(
                height: 15.0,
                width: 2.0,
                color: const Color.fromARGB(77, 29, 28, 28),
                padding: const EdgeInsets.only(right: 3.0),
              ),
              CustomSelectionWidget(image: 'assets/images/helmet.png', text: ' Notes'),
            ],
          ),
        )
      ],
    ),
  );
}

Widget buildBottomSheet(BuildContext context) {
  final calculatedFare = 100.00;
  final serviceType = 'Passenger';
  final duration = '2-10 min(s)';

  return Container(
    padding: EdgeInsets.fromLTRB(15, 16, 15, 20),
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), spreadRadius: 5, blurRadius: 10)],
        borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
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
                Text('  $serviceType  ', style: Theme.of(context).textTheme.titleSmall),
                Icon(Icons.arrow_forward_ios_rounded, size: 12)
              ],
            ), //Add 1.Leading icon & 2.Action button
            Text(duration),
            Text('P $calculatedFare', style: Theme.of(context).textTheme.titleLarge), //use diff fontfamily for Peso sign
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Book'),
          ),
        )
      ],
    ),
  );
}
