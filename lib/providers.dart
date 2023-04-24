import 'dart:async';

import 'package:clear_avenues/features/analysis/AnalysisService.dart';
import 'package:clear_avenues/models/Association.dart';
import 'package:clear_avenues/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';

import 'constants.dart';
import 'features/reporting/ReportService.dart';
import 'models/Notification.dart';
import 'models/Report.dart';

final userProvider = NotifierProvider<UserNotifier, User>(() {
  return UserNotifier();
});

class UserNotifier extends Notifier<User> {
  @override
  User build() {
    return User();
  }

  void logout() {
    state = User();
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setAccountType(String type) {
    state = state.copyWith(accountType: type);
  }

  Future<bool> submitReport(String reportType, String description,
      String latitude, String longitude, String locationId) async {
    final client = ref.read(httpClientProvider);
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
    var response = await client.post(url);
    if (response.statusCode == 200) {
      return true;
    }
    debugPrint("Error submitting report: ${response.body}");
    return false;
  }
}

final httpClientProvider = Provider((ref) => Client());

final markersProvider =
    FutureProvider.family<Iterable<Marker>, BuildContext>((ref, context) async {
  final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), "assets/images/TrafficCone64.png");
  final reportList = ref.watch(allReportsProvider);
  var reports = reportList.value;
  /*
  var markers = reports?.map((markerInfo) => Marker(
      markerId: MarkerId(markerInfo.reportId.toString()),
      draggable: false,
      position: LatLng(
        markerInfo.reportLocationLatitude,
        markerInfo.reportLocationLongitude,
      ),
      icon: markerIcon,
      infoWindow: InfoWindow(
          title: convertType(markerInfo.reportType),
          onTap: () {
            context.pushNamed("report_info", queryParams: {
              'p1': convertType(markerInfo.reportType),
              'p2': markerInfo.reportStatus,
              'p3': markerInfo.reportDate,
              'p4': markerInfo.reportComment,
              'p5': markerInfo.reportLocationLatitude.toString(),
              'p6': markerInfo.reportLocationLongitude.toString(),
            });
          })));
  */
  var markers = reports?.map((markerInfo)  {
    String readableReportType = convertType(markerInfo.reportType);

    /* Right now there is an issue where it flash between the initial set icon
     * and the icon it gets set to... though it technically sets it?
    setMarkerIcon() async {
        markerIcon = await getMapMarker(markerInfo.reportType);
    }
    setMarkerIcon();
    */
    return Marker(
      markerId: MarkerId(markerInfo.reportId.toString()),
      draggable: false,
      position: LatLng(
        markerInfo.reportLocationLatitude,
        markerInfo.reportLocationLongitude,
      ),
      icon: markerIcon,
      infoWindow: InfoWindow(
          title: readableReportType,
          onTap: () {
            context.pushNamed("report_info", queryParams: {
              'p1': readableReportType,
              'p2': markerInfo.reportStatus,
              'p3': markerInfo.reportDate,
              'p4': markerInfo.reportComment,
              'p5': markerInfo.reportLocationLatitude.toString(),
              'p6': markerInfo.reportLocationLongitude.toString(),
            });
          }));
  });

  if (markers != null) return markers;
  return <Marker>{};
});

//Temporary at the moment until I talk to Keshaun more about this
Future<BitmapDescriptor> getMapMarker(String? reportType) async {
  BitmapDescriptor markerImage = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), "assets/images/Pothole64.png");
  return markerImage;
}
//Converts the report types into readable versions
String convertType(String? reportType) {
  switch (reportType) {
    case "missing_signage":
      return "Missing Sign";
    case "debris":
      return "Debris";
    case "flooding":
      return "Flooding";
    case "pothole":
      return "Pothole";
    case "obstructed_sign":
      return "Obstructed Sign";
    case "vehicle_accident":
      return "Vehicular Related";
    default:
      return "Other";
  }
}

final allReportsProvider = StreamProvider<List<Report>>((ref) async* {
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    List<Report>? reports = await ReportService.getAllReports(ref);
    if (reports != null) {
      yield reports;
    }
  }
});

// # From https://gist.github.com/mskasal/326d29626dcd169a4d1b4a142081f6ee
class PersonLocationProvider extends ChangeNotifier {
  final Location _location = Location();
  late final PermissionStatus _permissionGranted;
  StreamController<LocationData> currentLocation = StreamController.broadcast();

  PersonLocationProvider() {
    _init();
  }

  _checkPermission() async {
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  _init() {
    _checkPermission();
    currentLocation.addStream(_location.onLocationChanged);
  }
}

final locationProvider = ChangeNotifierProvider<PersonLocationProvider>((ref) {
  return PersonLocationProvider();
});

final locationStreamProvider = StreamProvider.autoDispose<LocationData>(
  (ref) {
    ref.keepAlive();
    final stream = ref.read(locationProvider).currentLocation.stream;

    return stream;
  },
);

final savedNotificationsProvider =
    NotifierProvider<SavedNotifications, List<MyNotification>>(() {
  return SavedNotifications();
});

class SavedNotifications extends Notifier<List<MyNotification>> {
  // Sets up a default notification when app loads

  @override
  build() {
    return [MyNotification()];
  }

  void addNotification(MyNotification notif) {
    state = [...state, notif];
  }

  void removeNotification(int index) {
    state = state..removeAt(index);
    ref.notifyListeners();
  }

  int length() => state.length;
}

final allAssociationsProvider = StreamProvider<List<Association>>((ref) async* {
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    List<Association>? associations =
        await AnalysisService.getAllAssociations(ref);
    if (associations != null) {
      yield associations;
    }
  }
});

/*
final associationMarkersProvider =
FutureProvider.family<Iterable<Marker>, BuildContext>((ref, context) async {
  final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), "assets/images/TrafficCone64.png");
  final associationList = ref.watch(allAssociationsProvider);
  var associations = associationList.value;
  var markers = associations?.map((markerInfo) => Marker(
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

            });
          })));
  if (markers != null) return markers;
  return <Marker>{};
});
*/
