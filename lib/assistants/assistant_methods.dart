import 'package:angkas_clone_app/assistants/request_assistant.dart';
import 'package:angkas_clone_app/models/directions.dart';
import 'package:angkas_clone_app/utils/constants/api_keys.dart';
import 'package:geolocator/geolocator.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoOrdinates(Position position, context) async {
    String apiUrl = "https://maps.googleapis.com/maps/apt/geocode/json3lating=${position.latitude}, ${position.longitude}&key=${APIKeys.googleMaps}";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occured. Failed. No Response.") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      //Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }
}
