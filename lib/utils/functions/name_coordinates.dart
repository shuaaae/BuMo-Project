import 'package:angkas_clone_app/utils/constants/api_keys.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String apiKey = APIKeys.googleMaps;

Future<String?> getLocationName(double latitude, double longitude) async {
  String url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

  try {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        return data['results'][0]['formatted_address'];
      }
    }
  } catch (e) {
    print('Error getting location name: $e');
  }
  return null;
}
