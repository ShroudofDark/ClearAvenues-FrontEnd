/// This file will contain a lot of data that can be passed between screens easily
/// Global variables are usually a no-no, but this is a quick and dirty way to get this
/// set up

import 'dart:convert';
import 'package:clear_avenues/constants.dart';
import 'package:clear_avenues/models/Association.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

bool isDemoing = false;
LatLng newCurrLoc = const LatLng(0,0);
String overrideAccountType = "Citizen";


setStartLocation(double latitude, double longitude) {
  newCurrLoc = LatLng(latitude, longitude);
}

/// Does not change the account of the user in database, only logged in instance
setAccountType(String type) {
  overrideAccountType = type;
}

/// Force the database to update all intensities
/// Right now the database updates intensities whenever a report is made
/// A real world product would probably just have the server call an update whenever
/// an accident or report is added to the database, but alas.
forceUpdateAllIntensities() async {

  List<Association> associationList;

  try {
    var url = Uri(
        scheme: 'http',
        host: Constants.serverIP,
        port: Constants.serverPort,
        path: '/locations');
    var response = await get(url);
    if (response.statusCode == 200) {
      Iterable jsonList = json.decode(response.body);
      var associations = List<Association>.from(
          jsonList.map((association) => Association.fromJson(association)));

      associationList = associations;
      for (var association in associationList) {
        try {
          var intensityUrl = Uri(
            scheme: 'http',
            host: Constants.serverIP,
            port: Constants.serverPort,
            path: '/locations/update/${association.associationId}',
          );
          var intensityResponse = await post(intensityUrl);

          if(intensityResponse.statusCode == 200) {
            continue;
          }
          else {
            debugPrint("Status Code for $url is ${intensityResponse.statusCode}");
          }

        } catch (error) {
          debugPrint("Error updating intensities: $error");
        }
      }
      debugPrint("All Intensities Updated");
    } else {
      debugPrint("Status Code for $url is ${response.statusCode}");
    }
  } catch (error) {
    debugPrint("Error getting all associations: $error");
  }
}