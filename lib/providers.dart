import 'dart:async';

import 'package:clear_avenues/features/analysis/AccidentService.dart';
import 'package:clear_avenues/features/analysis/AnalysisService.dart';
import 'package:clear_avenues/models/Accident.dart';
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

  Future<bool> submitReport(
      String reportType,
      String description,
      String latitude,
      String longitude,
      String locationId,
      String? imageHash) async {
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
          'locationId': locationId,
          'imageString': imageHash,
        });
    var response = await client.post(url);
    if (response.statusCode == 200) {
      //Intensity Score Update, was having difficulty getting this to update
      //Via backend even when I wrote my own command, so going to call one Matt made
      //Just so we have something that works
      var intensityUrl = Uri(
        scheme: 'http',
        host: Constants.serverIP,
        port: Constants.serverPort,
        path: '/locations/update/$locationId',
      );
      response = await client.post(intensityUrl);
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 200) {
        debugPrint("Didn't update intensity");
        return true;
      }
    }
    debugPrint("Error submitting report: ${response.body}");
    return false;
  }
}

final httpClientProvider = Provider((ref) => Client());

final markersProvider =
    FutureProvider.family<Iterable<Marker>, BuildContext>((ref, context) async {
  final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), "assets/images/icon.png");
  final reportList = ref.watch(allReportsProvider);
  var reports = reportList.value;
  var markers = reports?.map((markerInfo) {
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
              context.push('/report_info', extra: markerInfo);
            }));
  });

  if (markers != null) return markers;
  return <Marker>{};
});

//Temporary at the moment until I talk to Keshaun more about this
Future<BitmapDescriptor> getMapMarker(String? reportType) async {
  BitmapDescriptor markerImage = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), "assets/images/Pothole.png");
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
    do {
      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
    } while (
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed);
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
  @override
  build() {
    // Sets up a default notification when app loads

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

///----------------------------------
///       Analysis Providers
///----------------------------------

final heatmapPointsProvider = FutureProvider<List<WeightedLatLng>>((ref) async {
  final associationList = ref.watch(allAssociationsProvider);

  List<WeightedLatLng> pointsList = [
    const WeightedLatLng(LatLng(36.88420, -76.306730), weight: 0.0),
  ];
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    if (associationList.hasValue) {
      for (final location in associationList.value!) {
        var reportsList = ref
            .watch(reportsByLocationProvider(location.associationId.toInt()));
        var reports = reportsList.value;
        if (reportsList.hasValue) {
          for (final report in reports!) {
            pointsList.add(WeightedLatLng(
                LatLng(report.reportLocationLatitude,
                    report.reportLocationLongitude),
                weight: (location.intensity.toDouble() / 3)));
            //weight: (1.0))); //Debugging weight
          }
        }
      }
      return pointsList;
    } else {
      return [
        const WeightedLatLng(LatLng(0, 0), weight: 0.0),
      ];
    }
  }
});

final associationMarkerProvider =
    FutureProvider.family<Iterable<Marker>, BuildContext>((ref, context) async {
  final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), "assets/images/icon.png");
  final associationList = ref.watch(allAssociationsProviderRef);
  var associations = associationList.value;
  var markers = associations?.map((markerInfo) {
    return Marker(
        markerId: MarkerId(markerInfo.associationId.toString()),
        draggable: false,
        position: LatLng(
          markerInfo.associationLocationLatitude,
          markerInfo.associationLocationLongitude,
        ),
        icon: markerIcon,
        infoWindow: InfoWindow(
            title: "Association Report of Area: ${markerInfo.associationId}",
            onTap: () {
              context.push('/association_info', extra: markerInfo);
            }));
  });
  if (markers != null) return markers;
  return <Marker>{};
});

//Without Ref
final allAssociationsProvider = StreamProvider<List<Association>>((ref) async* {
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    List<Association>? associations =
        await ref.watch(analysisServiceProvider).getAllAssociations();
    if (associations != null) {
      yield associations;
    }
  }
});

//With Ref

final allAssociationsProviderRef =
    StreamProvider<List<Association>>((ref) async* {
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    List<Association>? associations =
        await ref.watch(analysisServiceProvider).getAllAssociationsRef(ref);
    if (associations != null) {
      yield associations;
    }
  }
});

final analysisServiceProvider = Provider((Ref ref) => AnalysisService());

final reportsByLocationProvider =
    StreamProvider.family<List<Report>, int>((ref, loc) async* {
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    List<Report>? reports =
        await ReportService.getReportsByLocationRef(loc, ref);
    if (reports != null) {
      yield reports;
    }
  }
});

final accidentsByLocationProvider =
    StreamProvider.family<List<Accident>, int>((ref, loc) async* {
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    List<Accident>? accidents =
        await AccidentService.getReportsByLocationRef(loc, ref);
    if (accidents != null) {
      yield accidents;
    }
  }
});
