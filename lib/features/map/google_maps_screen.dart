import 'package:clear_avenues/features/map/CustomDatePickerTheme.dart';
import 'package:clear_avenues/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import '../../widgets/navigation_bar.dart';
import '../dev/demo_assist.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  loc.Location location = loc.Location();
  late Future cameraPosBuilder;
  late CameraPosition initialCameraPosition;
  bool isLoading = true;

  /*
  static const LatLng defaultLocation = LatLng(36.8855, -76.3058);
  CameraPosition defaultCameraPosition = const CameraPosition(target: defaultLocation, zoom: 17.0, tilt: 0, bearing: 0);
  */


  List<Marker> allMarkers = [];

  @override
  void initState() {
    setLocation() async {
      cameraPosBuilder = getUserStartCamera(location);
      initialCameraPosition = await cameraPosBuilder;
      isLoading = false;
    }
    setLocation();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final userName = user.name;
    final markers = ref.watch(markersProvider(context));

    return Scaffold(
      drawer: const NavBar(),
      //Edits where you can start a drag motion to open the side bar
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.05,
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: FutureBuilder(
        future: cameraPosBuilder,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text("check error!");
            } else if (snapshot.hasData) {
              return Stack(
                children: [
                  GoogleMap(
                      myLocationEnabled: true,
                      initialCameraPosition: initialCameraPosition,
                      markers: Set.from(markers.value!),

                      onTap: (latLng) {
                        if(userName != null) {
                          reportMethodChoice(context, latLng, userName);
                        }
                      }),
                ],
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      /**
       * Button Location to submit a report. When selected the button
       * is to open the report screen and transfer user to that screen.
       */
      floatingActionButton: isLoading
          ? null
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: FloatingActionButton.extended(
                icon: const Icon(Icons.report),
                label: const Text('Report Unsafe Condition'),
                onPressed: () {
                  if (userName != null) {
                    LatLng currCoords = const LatLng(0, 0);
                    getCurrCoords() async {
                      loc.LocationData userLocation =
                          await location.getLocation();
                      currCoords =
                          LatLng(userLocation.latitude!, userLocation.longitude!);
                      if (context.mounted) {
                        reportMethodChoice(context, currCoords, userName);
                      }
                    }

                    //If not demoing do this
                    if (!isDemoing) {
                      getCurrCoords();
                    }
                    //If demoing do this
                    else {
                      currCoords = newCurrLoc;
                      reportMethodChoice(context, currCoords, userName);
                    }
                  }
                },
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

void reportMethodChoice(BuildContext context, LatLng coordsToUse, String userName) {

  Widget submitButton = TextButton(
    onPressed: () {
      context.pop();
      context.push("/report", extra: coordsToUse);
    },
    child: const Text("Submit"),
  );
  Widget reminderButton = TextButton(
    onPressed: () {
      context.pop();
      /*
       * Likely in hindsight a better method of doing this would
       * be to just ask for "hours from now", pick from drop down, and so
       * forth. -Jacob
       */
      //Limits user from picking time before current time
      DateTime dateLimitMin = DateTime.now().copyWith(minute: DateTime.now().minute+1);
      //Limit user from picking something so far out that it makes no sense
      DateTime dateLimitMax = DateTime.now().copyWith(day: DateTime.now().day+5);
      //Set global variable for CustomDatePicker
      selectedTime = dateLimitMin;
      DatePicker.showDatePicker(
        context,
        dateFormat: 'dd HH:mm',
        initialDateTime: dateLimitMin,
        minDateTime: dateLimitMin,
        maxDateTime: dateLimitMax,
        onMonthChangeStartWithFirstDate: true,
        onChange: (dateTime, List<int> index) {
          selectedTime = dateTime;
        },
        pickerTheme: MyDateTimePickerTheme(context, userName, coordsToUse)
      );
    },
    child: const Text("Remind Me Later"),
  );
  Widget cancelButton = TextButton(
    onPressed: () {
      context.pop();
    },
    child: const Text("Close"),
  );

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose"),
        content: const Text("Would you like to submit a report now?"),
        actions: [
          submitButton,
          reminderButton,
          cancelButton,
        ],
      ));
}

Future<CameraPosition> getUserStartCamera(loc.Location location) async {
  //If application is not demonstrating, get actual current location
  if (!isDemoing) {
    //Do a one time check to determine user's starting location
    loc.LocationData userLocation = await location.getLocation();
    LatLng conversion = LatLng(userLocation.latitude!, userLocation.longitude!);
    return CameraPosition(target: conversion, zoom: 17.0, tilt: 0, bearing: 0);
  }

  //If the application is demonstrating, do this instead
  return CameraPosition(target: newCurrLoc, zoom: 17.0, tilt: 0, bearing: 0);
}
