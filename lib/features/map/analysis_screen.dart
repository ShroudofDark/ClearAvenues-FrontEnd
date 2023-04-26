import 'package:clear_avenues/features/dev/demo_assist.dart';
import 'package:clear_avenues/providers.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  late GoogleMapController mapController;
  loc.Location location = loc.Location();
  late Future cameraPosBuilder;
  late CameraPosition initialCameraPosition;
  bool isLoading = false;

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
    final heatmapPoints = ref.watch(heatmapPointsProvider);
    final associationMarkers = ref.watch(associationMarkerProvider(context));
    //TODO add ! back in front
    if ((user.accountType == null || user.accountType == "standard")) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Analysis Map'),
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
                      heatmaps: {
                        Heatmap(
                          heatmapId: const HeatmapId("One"),
                          data: heatmapPoints.value
                              ?? [const WeightedLatLng(LatLng(0,0), weight: 0)],
                          radius: 50,
                        )
                      },
                        //markers: Set.from(associationMarkers.value!),
                        markers: associationMarkers.hasValue ? Set.from(associationMarkers.value!): {},
                        myLocationEnabled: true,
                        initialCameraPosition: initialCameraPosition,
                    ),
                  ],
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: isLoading
            ? null
            : FloatingActionButton.extended(
              label: Text("Debug Button"),
              onPressed: () async {
                debugPrint(associationMarkers.value.toString());
               },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }
    else if(user.accountType == "standard") {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Analysis Map"),
        ),
        body: const Center(
            child: Text(
              "You must be either a municipality or institute to view",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            )
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Analysis Map"),
        ),
        body: const Center(
            child: Text(
              "Login to view the analysis map",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            )
        ),
      );
    }
  }
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