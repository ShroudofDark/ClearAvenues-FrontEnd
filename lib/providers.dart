import 'package:clear_avenues/models/User.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'features/reporting/ReportService.dart';
import 'models/Report.dart';

final userProvider = NotifierProvider<UserNotifier, User>(() {
  return UserNotifier();
});

class UserNotifier extends Notifier<User> {
  @override
  User build() {
    return User();
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setAccountType(String type) {
    state.copyWith(accountType: type);
  }

  Future<bool> submitReport(String reportType, String description,
      String latitude, String longitude, String locationId) async {
    var url = Uri(
        scheme: 'http',
        host: Constants.serverIP,
        port: Constants.serverPort,
        path: '/users/${state.email}/reports',
        queryParameters: {
          'reportType': reportType,
          'latitude': latitude,
          'longitude': longitude,
          'comment': description,
          'locationId': locationId
        });
    var response = await post(url);
    if (response.statusCode == 200) {
      return true;
    }
    debugPrint("Error submitting report: ${response.body}");
    return false;
  }
}

// Note to Self
// * Create HTTPClient provider and use this client across entire app for
// efficiency

final markersProvider =
    FutureProvider.family<Iterable<Marker>, BuildContext>((ref, context) async {
  final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), "assets/images/TrafficCone64.png");
  final reportList = ref.watch(allReportsProvider);
  var reports = reportList.value;
  var markers = reports?.map((markerInfo) => Marker(
      markerId: MarkerId(markerInfo.reportId.toString()),
      draggable: false,
      position: LatLng(
        markerInfo.reportLocationLatitude,
        markerInfo.reportLocationLongitude,
      ),
      icon: markerIcon,
      infoWindow: InfoWindow(
          title: markerInfo.reportComment,
          onTap: () {
            context.pushNamed("report_info", queryParams: {
              'p1': markerInfo.reportType,
              'p2': markerInfo.reportStatus,
              'p3': markerInfo.reportDate,
              'p4': markerInfo.reportComment,
              'p5': markerInfo.reportLocationLatitude.toString(),
              'p6': markerInfo.reportLocationLongitude.toString(),
            });
          })));
  if (markers != null) return markers;
  return <Marker>{};
});

final allReportsProvider = StreamProvider<List<Report>>((ref) async* {
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    List<Report>? reports = await ReportService.getAllReports();
    if (reports != null) {
      yield reports;
    }
  }
});
