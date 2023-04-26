import 'dart:async';
import 'dart:convert';

import 'package:clear_avenues/constants.dart';
import 'package:clear_avenues/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../models/Report.dart';

// TODO: Move this logic into a getUserReports function inside ReportService
// similar to what was done for the provider above

final userReportProvider = StreamProvider.autoDispose<List<Report>>((ref) {
  final user = ref.watch(userProvider);
  final client = ref.read(httpClientProvider);
  final controller = StreamController<List<Report>>();

  Future<void> fetchReports() async {
    final url = Uri.parse(
        "http://${Constants.serverIP}:${Constants.serverPort}/users/${user.email}/reports");
    List<Report>? reports;
    try {
      Response resp = await client.get(url);
      if (resp.statusCode == 200) {
        Iterable jsonList = json.decode(resp.body);
        reports = List<Report>.from(
            jsonList.map((report) => Report.fromJson(report)));
        controller.add(reports);
      }
    } catch (err) {
      debugPrint("Error getting reports: ${err.toString()}");
    }
  }

  var timer = Timer.periodic(const Duration(seconds: 1), (count) async {
    await fetchReports();
  });
  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });
  return controller.stream;
});
