import 'package:angkas_clone_app/components/network_utils.dart';
import 'package:angkas_clone_app/models/autocomplate_prediction.dart';
import 'package:angkas_clone_app/models/place_auto_complate_response.dart';
import 'package:angkas_clone_app/utils/constants/api_keys.dart';
import 'package:angkas_clone_app/widgets/location_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({Key? key}) : super(key: key);

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  List<AutocompletePrediction> placePredictions =
      []; //List for search locations

  void placeAutocomplate(String query) async {
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
      appBar: AppBar(),
      body: Column(
        children: [
          Form(
            //TEXT FIELD FOR PICK-UP LOCATION
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                onChanged: (value) {
                  placeAutocomplate(value);
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search your location",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SvgPicture.asset(
                      "assets/icons/location_pin.svg",
                      height: 19,
                      width: 19,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            color: Colors.grey,
          ),
          Padding(
            //CURRENT LOCATION BUTTON
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              onPressed: () {
                placeAutocomplate("Dubai");
              },
              icon: SvgPicture.asset(
                "assets/icons/location.svg",
                height: 16,
              ),
              label: const Text("Use my Current Location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.black,
                elevation: 0,
                fixedSize: const Size(double.infinity, 50),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          const Divider(
            height: 2,
            thickness: 2,
            color: Colors.grey,
          ),
          //LIST TILES FOR SEARCHED RESULTS
          Expanded(
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder: (context, index) => LocationListTile(
                press: () {},
                location: placePredictions[index].description!,
              ),
            ),
          )
        ],
      ),
    );
  }
}
