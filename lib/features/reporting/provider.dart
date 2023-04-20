import 'dart:convert';
import 'package:clear_avenues/constants.dart';
import 'package:clear_avenues/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../models/Report.dart';


// TODO: Move this logic into a getUserReports function inside ReportService
// similar to what was done for the provider above
final userReportProvider = StreamProvider<List<Report>>((ref) async* {
  final user = ref.watch(userProvider);
  final client = ref.read(httpClientProvider);
  while (true) {
    final url = Uri.parse(
        "http://${Constants.serverIP}:${Constants.serverPort}/users/${user.email}/reports");
    List<Report>? reports;
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      Response resp = await client.get(url);
      if (resp.statusCode == 200) {
        Iterable jsonList = json.decode(resp.body);
        reports = List<Report>.from(
            jsonList.map((report) => Report.fromJson(report)));
        yield reports;
      }
    } catch (err) {
      debugPrint("Error getting reports: ${err.toString()}");
    }
  }
});
