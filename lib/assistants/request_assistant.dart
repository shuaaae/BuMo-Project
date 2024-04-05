import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;

class RequestAssistant {
  static Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));

    try {
      if (httpResponse.statusCode == 200) // successful
      {
        String reponseData = httpResponse.body; //json
        var decodeResponseData = jsonDecode(reponseData);
        return decodeResponseData;
      } else {
        return "Error Occured. Failed. No Response.";
      }
    } catch (exp) {
      return "Error Occured. Failed. No Response.";
    }
  }
}
