import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../models/Report.dart';

final reportProvider = StreamProvider<List<Report>>((ref) async* {
  while (true) {
    final url = Uri.parse("http://10.254.106.216:8080/reports");
    List<Report>? reports = null;
    await Future.delayed(const Duration(milliseconds: 1000));
    Response resp = await get(url);
    if (resp.statusCode == 200) {
      Iterable jsonList = json.decode(resp.body);
      reports =
          List<Report>.from(jsonList.map((report) => Report.fromJson(report)));
      yield reports;
    }
  }
});