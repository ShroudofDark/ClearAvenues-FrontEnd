import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReportInfoScreen extends StatefulWidget {
  final String? reportType;
  final String? reportStatus;
  final String? reportTime;
  final String? reportDecription;
  final String? reportLat;
  final String? reportLon;


  const ReportInfoScreen({super.key, this.reportType, this.reportStatus,
    this.reportTime, this.reportDecription, this.reportLat, this.reportLon});

  // get coordinates => {double.tryParse(ReportLat ?? ''), double.tryParse(ReportLon ?? '')};

  @override
  State<ReportInfoScreen> createState() => _ReportInfoScreenState();
}

class _ReportInfoScreenState extends State<ReportInfoScreen> {
  String _address = "";

  List<String> reportStatusOptions = ["Active", "Inactive"];

  late final coords;

  @override
  void initState() {
    super.initState();

    //Set Display Text when screen starts
    var tempLat = double.tryParse(widget.reportLat as String);
    var tempLon = double.tryParse(widget.reportLon as String);

    _getAddressFromCoords();

    coords = LatLng(tempLat!, tempLon!);
  }


  @override
  Widget build(BuildContext context) {
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
                          text: "${widget.reportType}\n",
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
                          text: "${widget.reportStatus}\n",
                          style: TextStyle(
                            fontSize: 16,
                            color: (widget.reportStatus == reportStatusOptions[0]) ? Colors.green : Colors.red,
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
                    text: "${widget.reportTime}\n",
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
              child: FutureBuilder<String?>(
                future: _getCoordsText(),
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!);
                    } else {
                      return Text(
                        _address,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )
            ),

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
                              text: "${coords.longitude.toStringAsFixed(6)}\n",
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
                text: "Report ReportDecription: \n",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: "${widget.reportDecription}\n",
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
            Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Is this issue still here?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ]
            ),

            Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    debugPrint("yes");
                    // TODO send to request database
                  },
                  child: const Text('Yes'),
                ),
                const SizedBox(width: 16), // Add some spacing between the buttons
                ElevatedButton(
                  onPressed: () {
                    debugPrint("no");
                    // TODO send to request database
                  },
                  child: const Text('no'),
                ),
              ]
            ),
          ], //column children
        ),
      )
    );
  }

  Future<String?> _getCoordsText() async {
    if (coords == null) {
      return null;
    } else {
      return coords;
    }
  }

  Future<void> _getAddressFromCoords() async {
    var tempLat = double.tryParse(widget.reportLat as String) as double;
    var tempLon = double.tryParse(widget.reportLon as String) as double;

    await placemarkFromCoordinates(tempLat, tempLon)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _address =
        '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
      });
    });
  }

}