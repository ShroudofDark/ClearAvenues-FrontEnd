import 'package:clear_avenues/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/Report.dart';

class ReportInfoScreen extends ConsumerStatefulWidget {
  final Report report;

  const ReportInfoScreen({super.key, required this.report});

  @override
  ConsumerState<ReportInfoScreen> createState() => _ReportInfoScreenState();
}

class _ReportInfoScreenState extends ConsumerState<ReportInfoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    LatLng coords = LatLng(widget.report.reportLocationLatitude,
        widget.report.reportLocationLongitude);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Report Info'),
        ),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "Report Type: ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: "${widget.report.reportType}\n",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "Report Status: ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: "${widget.report.reportStatus}\n",
                            style: TextStyle(
                              fontSize: 16,
                              color: (widget.report.reportStatus ==
                                      ReportStatus.submitted.name)
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  text: "Report Time: ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: "${widget.report.reportDate}\n",
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 3.0),
                    color: Colors.white,
                  ),
                  child: FutureBuilder(
                    future: _getAddressFromCoords(coords),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Text(
                          snapshot.data!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  )),
              Stack(
                children: [
                  SizedBox(
                    height: 250,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 3.0, color: Colors.green),
                      ),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: coords, zoom: 20.0, tilt: 0, bearing: 0),
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,

                        //disables movement of map
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        rotateGesturesEnabled: false,

                        markers: {
                          Marker(
                            markerId: const MarkerId("location"),
                            draggable: false,
                            position: coords,
                            infoWindow:
                                const InfoWindow(title: "location of issue"),
                          ),
                        },
                        onMapCreated: (GoogleMapController controller) {
                          controller
                              .showMarkerInfoWindow(const MarkerId("location"));
                        },
                      ),
                    ),
                  ),
                  // Top layer text
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Latitude: ",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: "${coords.latitude.toStringAsFixed(6)}\n",
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Longitude: ",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "${coords.longitude.toStringAsFixed(6)}\n",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              RichText(
                text: TextSpan(
                  text: "Report Description: \n",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: "${widget.report.reportComment}\n",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
                height: 16,
                indent: 16,
                endIndent: 16,
              ),
              const SizedBox(height: 24.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                Text(
                  "Is this issue still here?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ]),
              user.accountType == "municipality"
                  ? ElevatedButton(
                      onPressed: () {}, child: const Text("Close Report"))
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ElevatedButton(
                        onPressed: () {
                          debugPrint("yes");
                          // TODO send to request database
                        },
                        child: const Text('Yes'),
                      ),
                      const SizedBox(
                          width: 16), // Add some spacing between the buttons
                      ElevatedButton(
                        onPressed: () {
                          debugPrint("no");
                          // TODO send to request database
                        },
                        child: const Text('no'),
                      ),
                    ]),
            ], //column children
          ),
        ));
  }

  Future<String?> _getAddressFromCoords(LatLng coords) async {
    String? address;
    await placemarkFromCoordinates(coords.latitude, coords.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      address =
          '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
    });
    return address;
  }
}
