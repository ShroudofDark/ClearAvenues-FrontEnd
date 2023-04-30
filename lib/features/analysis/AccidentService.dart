import 'dart:convert';

import 'package:clear_avenues/constants.dart';
import 'package:clear_avenues/models/Accident.dart';
import 'package:clear_avenues/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccidentService {
  static Future<List<Accident>?> getAllReports(Ref ref) async {
    try {
      var url = Uri(
          scheme: 'http',
          host: Constants.serverIP,
          port: Constants.serverPort,
          path: '/accidents');
      var response = await ref.read(httpClientProvider).get(url);
      if (response.statusCode == 200) {
        Iterable jsonList = json.decode(response.body);
        var accidents = List<Accident>.from(
            jsonList.map((report) => Accident.fromJson(report)));
        return accidents;
      } else {
        return null;
      }
    } catch (error) {
      debugPrint("Error getting all accidents: $error");
      return null;
    }
  }

  static Future<List<Accident>?> getReportsByLocationRef(int id, Ref ref) async {
    try {
      var url = Uri(
          scheme: 'http',
          host: Constants.serverIP,
          port: Constants.serverPort,
          path: '/accidents/bylocation/$id');
      var response = await ref.read(httpClientProvider).get(url);
      if (response.statusCode == 200) {
        Iterable jsonList = json.decode(response.body);
        var accidents = List<Accident>.from(
            jsonList.map((accident) => Accident.fromJson(accident)));
        return accidents;
      } else {
        return null;
      }
    } catch (error) {
      debugPrint("Error getting accidents by location: $error");
      return null;
    }
  }
}