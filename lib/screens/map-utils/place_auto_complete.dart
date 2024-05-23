import 'dart:convert';
import 'package:angkas_clone_app/components/network_utils.dart';
import 'package:angkas_clone_app/models/autocomplete_prediction.dart';
import 'package:angkas_clone_app/models/place_auto_complete_response.dart';
import 'package:angkas_clone_app/utils/constants/api_keys.dart';

Future<void> placeAutocomplete(String query, bool isPickup,
    Function(List<AutocompletePrediction>) callback) async {
  Uri uri =
      Uri.https("maps.googleapis.com", 'maps/api/place/autocomplete/json', {
    "input": query,
    "key": APIKeys.googleMaps,
  });

  String? response = await NetworkUtils.fetchUrl(uri);
  if (response != null) {
    PlaceAutocompleteResponse result =
        PlaceAutocompleteResponse.parseAutocompleteResult(response);
    if (result.predictions != null) {
      callback(result.predictions!);
    }
  }
}
