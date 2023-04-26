import 'dart:async';
import 'dart:math';

import 'package:clear_avenues/constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart';

class GeneratedReport {
  late String reportComment;
  late String reportDate;
  late String reportType;
  late double reportLocationLatitude;
  late double reportLocationLongitude;
  late int locationId;

  Client client = Client();

  var emails = [
    "kbank@school.edu",
    "mwills@odu.edu",
    "jmcfad@odu.edu",
  ];
  var roadIssues = {
    "Large pothole in the road": "pothole",
    "There is a missing stop sign": "missing_signage",
    "Debris on the road": "debris",
    "Vehicle accident ahead": "vehicle_accident",
    "Vandalism on road signs": "vandalism",
    "Sign obstructed by foliage": "sign_blocked_foliage",
    "Sign obstructed by vehicle": "sign_blocked_vehicle",
    "Sign obstructed by other sign": "sign_blocked_sign",
    "Sign obstructed by building": "sign_blocked_building",
    "Damaged road sign": "damaged_sign",
    "Flooding on the road": "flooding",
    "Foggy conditions": "fog",
    "Blinding rain": "blinding_rain",
    "Blinding sun": "blinding_sun",
    "Hail on the road": "hail",
    "Icy road conditions": "ice",
    "Unplowed road": "unplowed_road",
    "Leaves on the road": "leaves",
    "Fallen tree on the road": "fallen_tree",
    "Dead animal on the road": "dead_animal",
    "Spill of hazardous material": "spill_material",
    "Blind turn ahead": "blind_turn",
    "Overgrowth on the road": "overgrowth",
    "Animal crossing ahead": "animal_crossing",
    "Other road issue": "other"
  }.entries.toList();
  final random = Random();
  GeneratedReport.private() {
    var typeAndComment = roadIssues[random.nextInt(roadIssues.length)];
    reportComment = typeAndComment.key;
    reportType = typeAndComment.value;
    reportDate = randomDateBetween(
            start: DateTime.utc(2023, 5, 20, 0, 0, 0),
            end: DateTime.utc(2023, 6, 13, 0, 0, 0))
        .toString();

    var coords = randomGeo([36.8865117, -76.3092059], 2000);
    reportLocationLatitude = coords['latitude'];
    reportLocationLongitude = coords['longitude'];
  }

  Future<GeneratedReport> _init() async {
    locationId = await getZip();
    return this;
  }

  static Future<GeneratedReport> create() async {
    var report = GeneratedReport.private();
    return report._init();
  }

  Future<int> getZip() async {
    var response = await placemarkFromCoordinates(
        reportLocationLatitude, reportLocationLongitude);

    if (response.isEmpty) return 0;
    if (response[0].postalCode != null) {
      return int.parse(response[0].postalCode!);
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = reportComment;
    data['reportDate'] = reportDate;
    data['latitude'] = reportLocationLatitude;
    data['longitude'] = reportLocationLongitude;
    data['reportType'] = reportType;
    data['locationId'] = locationId;
    data['date'] = reportDate;
    return data;
  }

  @override
  String toString() {
    return """
-------------------------------------------------
Type: $reportType
Comment: $reportComment
Coordinates: $reportLocationLatitude, $reportLocationLongitude
Zip Code: $locationId
Time: $reportDate
-------------------------------------------------
""";
  }

  Future<bool> submit() async {
    var randomEmail = _getRandomEmail();
    var response = await client.post(Uri(
        scheme: 'http',
        host: Constants.serverIP,
        port: Constants.serverPort,
        path: '/users/$randomEmail/reports',
        queryParameters: toJson()));
    if (response.statusCode == 200) return true;
    return false;
  }

  String _getRandomEmail() {
    return emails[random.nextInt(emails.length)];
  }

  Map randomGeo(center, radius) {
    var y0 = center[0];
    var x0 = center[1];
    var rd = radius / 111300;

    var u = random.nextDouble();
    var v = random.nextDouble();

    var w = rd * sqrt(u);
    var t = 2 * pi * v;
    var x = w * cos(t);
    var y = w * sin(t);

    //var xp = x / cos(y0);

    return {'latitude': y + y0, 'longitude': x + x0};
  }

  DateTime randomDateBetween({required DateTime start, required DateTime end}) {
    int range = end.difference(start).inDays;
    int randomDay = Random().nextInt(range);
    return start.add(Duration(days: randomDay));
  }
}
