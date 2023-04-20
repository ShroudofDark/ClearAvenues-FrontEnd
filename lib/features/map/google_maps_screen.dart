import 'package:clear_avenues/features/map/report_method_dialog.dart';
import 'package:clear_avenues/providers.dart';
import 'package:clear_avenues/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final currLocation = ref.watch(locationStreamProvider).value;

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
                        if (userName != null) {
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
          : FloatingActionButton.extended(
              icon: const Icon(Icons.report),
              label: const Text('Report Unsafe Condition'),
              onPressed: () {
                if (currLocation == null) {
                  showMySnackbar(context,
                      "Cannot obtain location. Have you given permission?");
                } else if (userName == null) {
                  showMySnackbar(context, "You must sign in first!");
                } else {
                  reportMethodChoice(
                      context,
                      LatLng(currLocation.latitude!, currLocation.longitude!),
                      userName);
                }
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

void reportMethodChoice(
    BuildContext context, LatLng coordsToUse, String userName) {
  showDialog(
      context: context, builder: (context) => ReportMethodDialog(coordsToUse));
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
