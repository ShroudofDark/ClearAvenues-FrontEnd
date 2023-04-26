import 'dart:async';

import 'package:clear_avenues/features/analysis/AnalysisService.dart';
import 'package:clear_avenues/models/Association.dart';
import 'package:clear_avenues/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;
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

  List<WeightedLatLng> pointsList = [const WeightedLatLng(LatLng(36.88420, -76.306730), weight: 0.0),];
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    if (associationList.hasValue) {
      for (final location in associationList.value!){
        var reportsList = ref.watch(reportsByLocationProvider(location.associationId.toInt()));
        var reports = reportsList.value;
        if (reportsList.hasValue) {
          for (final report in reports!){
            pointsList.add(WeightedLatLng(
                LatLng(report.reportLocationLatitude, report.reportLocationLongitude),
                //weight: (location.intensity.toDouble()/3))); //Actual weighting system, use this when not debugging
                weight: (1.0)));
          }
        }
      }
      return pointsList;
    }
    else {
      return [const WeightedLatLng(LatLng(0, 0), weight: 0.0),];
    }
  }

});

final associationMarkerProvider = FutureProvider.family<Set<Marker>, BuildContext>((ref, context) async {

  final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), "assets/images/icon.png");
  final associationList = ref.watch(allAssociationsProvider);
  Set<Marker> markers = {};
  var count=0.0;
  while(true) {
    await Future.delayed(const Duration(seconds: 1));
    if (associationList.hasValue) {
      for(final location in associationList.value!) {
        var associationLocationList = ref.watch(associationLocationProvider(location.associationId.toInt()));
        var associationLocations = associationLocationList.value;
        if(associationLocationList.hasValue && associationLocations!.isNotEmpty) {
          count+=0.0001;
          debugPrint("${associationLocations[0].latitude},${associationLocations[0].longitude}");
          markers.add(
              Marker(
                markerId: MarkerId("${location.associationId}"),
                draggable: false,
                position: LatLng(
                  //associationLocations[0].latitude,
                  //associationLocations[0].longitude,
                  associationLocations[0].latitude+count,
                  associationLocations[0].longitude+count,
                ),
                icon: markerIcon,
                infoWindow: InfoWindow(
                    title: "Association Report Zipcode: ${location.associationId}",
                    onTap: () {
                      debugPrint("${location.associationId} AHAHAHAHAHHAAGASAFSAFSDSA");
                    }
                ),
              )
          );
        }
      }
      debugPrint("I'm Sending the Markers");
      return markers;
    }
    else {
      return {};
    }
  }
});

final associationMarkerProviderStream = StreamProvider.family<Set<Marker>, BuildContext>((ref, context) async* {

  final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), "assets/images/icon.png");
  final associationList = ref.watch(allAssociationsProvider);
  Set<Marker> markers = {};
  var count=0.0;
  while(true) {
    await Future.delayed(const Duration(seconds: 1));
    if (associationList.hasValue) {
      for(final location in associationList.value!) {
        var associationLocationList = ref.watch(associationLocationProvider(location.associationId.toInt()));
        var associationLocations = associationLocationList.value;
        if(associationLocationList.hasValue && associationLocations!.isNotEmpty) {
          count+=0.0001;
          debugPrint("${associationLocations[0].latitude},${associationLocations[0].longitude}");
          markers.add(
            Marker(
              markerId: MarkerId("${location.associationId}"),
              draggable: false,
              position: LatLng(
                associationLocations[0].latitude,
                associationLocations[0].longitude,
                //associationLocations[0].latitude+count,
                //associationLocations[0].longitude+count,
              ),
              icon: markerIcon,
                infoWindow: InfoWindow(
                    title: "Association Report Zipcode: ${location.associationId}",
                    onTap: () {
                      debugPrint("${location.associationId} AHAHAHAHAHHAAGASAFSAFSDSA");
                    }
                  ),
            )
          );
        }
      }
      debugPrint("I'm Sending the Markers");
      yield markers;
    }
    else {
      yield {};
    }
  }
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

final allAssociationsProviderRef = StreamProvider<List<Association>>((ref) async* {
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

final reportsByLocationProvider = StreamProvider.family<List<Report>, int>((ref,loc) async* {
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    List<Report>? reports = await ReportService.getReportsByLocationRef(loc, ref);
    if (reports != null) {
      yield reports;
    }
  }
});

final associationLocationProviderStream = StreamProvider.family<List<geo.Location>, int>((ref, zipCode) async* {
  while(true) {
    debugPrint("$zipCode");
    await Future.delayed(const Duration(seconds: 1));
    //List<geo.Location> locations = await geo.locationFromAddress("$zipCode", localeIdentifier: "en");
    List<geo.Location> locations = await geo.locationFromAddress("23508", localeIdentifier: "en");
    yield locations;
  }
});

final associationLocationProvider = FutureProvider.family<List<geo.Location>, int>((ref, zipCode) async {
    debugPrint("$zipCode");
    //List<geo.Location> locations = await geo.locationFromAddress("$zipCode", localeIdentifier: "en");
    List<geo.Location> locations = await geo.locationFromAddress("23508", localeIdentifier: "en");
    return locations;

});

final associationMarkerProvider2 =
  FutureProvider.family<Iterable<Marker>, BuildContext>((ref, context) async {
    final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/images/icon.png");
    final associationList = ref.watch(allAssociationsProviderRef);
    var associations = associationList.value;

    var markers = <Future<Marker>>{};

    if (associations != null) {
      markers = associations.map((markerInfo) async {
        List<geo.Location> associationLocation =
        await geo.locationFromAddress("${markerInfo.associationId}", localeIdentifier: "en");

        return Marker(
            markerId: MarkerId(markerInfo.associationId.toString()),
            draggable: false,
            position: LatLng(
              associationLocation[0].latitude,
              associationLocation[0].longitude,
            ),
            icon: markerIcon,
            infoWindow: InfoWindow(
                title: markerInfo.associationId.toString(),
                onTap: () {
                  context.push('/report_info', extra: markerInfo);
                }));
      }).toSet();
    }
    //There are instances of future markers here, but some reason its not getting supplied to the map right
    return await Future.wait(markers);
  });
