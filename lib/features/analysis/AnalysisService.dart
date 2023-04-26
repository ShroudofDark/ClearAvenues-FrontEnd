import 'dart:convert';
import 'package:clear_avenues/constants.dart';
import 'package:clear_avenues/models/Association.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AnalysisService {

  Future<List<Association>?> getAllAssociations() async {
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
        return associations;
      } else {
        return null;
      }
    } catch (error) {
      debugPrint("Error getting all associations: $error");
      return null;
    }
  }
}