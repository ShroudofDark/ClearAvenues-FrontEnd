import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../constants.dart';
import '../../models/Report.dart';
import '../../providers.dart';

class ReportService {
  final Ref ref;
  late final String? userEmail;
  late final Client client;
  ReportService(this.ref) {
    userEmail = ref.watch(userProvider).email;
  }

  static Future<Report?> getReport(int id, Ref ref) async {
    var url = Uri(
        scheme: 'http',
        host: Constants.serverIP,
        port: Constants.serverPort,
        path: '/reports/$id');
    try {
      var response = await ref.read(httpClientProvider).get(url);
      if (response.statusCode == 200) {
        return Report.fromJson(json.decode(response.body));
      }
      return null;
    } catch (error) {
      debugPrint("Error getting report: $error");
      return null;
    }
  }

  static Future<List<Report>?> getAllReports(Ref ref) async {
    try {
      var url = Uri(
          scheme: 'http',
          host: Constants.serverIP,
          port: Constants.serverPort,
          path: '/reports');
      var response = await ref.read(httpClientProvider).get(url);
      if (response.statusCode == 200) {
        Iterable jsonList = json.decode(response.body);
        var reports = List<Report>.from(
            jsonList.map((report) => Report.fromJson(report)));
        return reports;
      } else {
        return null;
      }
    } catch (error) {
      debugPrint("Error getting all reports: $error");
      return null;
    }
  }

  static Future<List<Report>?> getReportsByLocationRef(int id, Ref ref) async {
    try {
      var url = Uri(
          scheme: 'http',
          host: Constants.serverIP,
          port: Constants.serverPort,
          path: '/reports/bylocation/$id');
      var response = await ref.read(httpClientProvider).get(url);
      if (response.statusCode == 200) {
        Iterable jsonList = json.decode(response.body);
        var reports = List<Report>.from(
            jsonList.map((report) => Report.fromJson(report)));
        return reports;
      } else {
        return null;
      }
    } catch (error) {
      debugPrint("Error getting reports by location: $error");
      return null;
    }
  }
}