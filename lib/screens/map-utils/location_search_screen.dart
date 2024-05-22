import 'dart:convert';

import 'package:angkas_clone_app/components/network_utils.dart';
import 'package:angkas_clone_app/models/autocomplete_prediction.dart';
import 'package:angkas_clone_app/models/place_auto_complete_response.dart';
import 'package:angkas_clone_app/utils/constants/api_keys.dart';
import 'package:angkas_clone_app/utils/widgets/location_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pickupTextProvider = StateProvider<String>((ref) => '');
final destinationTextProvider = StateProvider<String>((ref) => '');

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({Key? key}) : super(key: key);

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  List<AutocompletePrediction> placePredictions = [];
  TextEditingController pickupController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  bool isPickupFocused = true;

  void placeAutocomplete(String query, bool isPickup) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        'maps/api/place/autocomplete/json', //unencoded path
        {
          "input": query, //query parameter
          "key": APIKeys.googleMaps, //API Key
        });

    //Then make GET request
    String? response = await NetworkUtils.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: pickupController,
                    onChanged: (value) {
                      placeAutocomplete(value, true);
                    },
                    onTap: () {
                      setState(() {
                        isPickupFocused = true;
                      });
                    },
                    textInputAction: TextInputAction.search,
                    maxLines: null,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Pick up from?",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: SvgPicture.asset(
                          color: Colors.white,
                          "assets/icons/location_pin.svg",
                          height: 19,
                          width: 19,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  indent: 55,
                  endIndent: 55,
                  height: 1,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    onChanged: (value) {
                      placeAutocomplete(value, false);
                    },
                    onTap: () {
                      setState(() {
                        isPickupFocused = false;
                      });
                    },
                    controller: destinationController,
                    textInputAction: TextInputAction.search,
                    maxLines: null,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Drop off to?",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                      prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Colors.red,
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: Row(
                  children: [
                    Icon(
                      Icons.my_location,
                      color: Theme.of(context).primaryColor,
                      size: 25,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Use My Current Location",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold))
                  ],
                ),
              )),
          Expanded(
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder: (context, index) => LocationListTile(
                location: placePredictions[index].description!,
                press: () async {
                  String placeId = placePredictions[index].placeId!;
                  Map<String, dynamic>? placeDetails =
                      await fetchPlaceDetails(placeId);

                  if (placeDetails != null) {
                    String address = placeDetails['formatted_address'];
                    double latitude =
                        placeDetails['geometry']['location']['lat'];
                    double longitude =
                        placeDetails['geometry']['location']['lng'];

                    setState(() {
                      if (isPickupFocused) {
                        pickupController.text = address;
                      } else {
                        destinationController.text = address;
                      }
                    });
                  }
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButton: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_outlined,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Choose From Map",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Future<Map<String, dynamic>?> fetchPlaceDetails(String placeId) async {
  Uri uri = Uri.https(
    "maps.googleapis.com",
    'maps/api/place/details/json',
    {
      "place_id": placeId,
      "key": APIKeys.googleMaps,
    },
  );

  String? response = await NetworkUtils.fetchUrl(uri);
  if (response != null) {
    Map<String, dynamic> result = json.decode(response);
    if (result['status'] == 'OK') {
      return result['result'];
    }
  }
  return null;
}
