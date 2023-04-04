import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/navigation_bar.dart';

class MarkersList {
  static List<Map<String, dynamic>> list = [
    {
      "title": "web center",
      "id": "1",
      "lat": 36.88666959507779,
      "lon": -76.306716388986,
      "reportType": "Debris",
      "reportStatus": "active",
      "reportTime": "30 mins ago",
      "reportDescription": "something interesting",
    },
    {
      "title": "dragas hall",
      "id": "2",
      "lat": 36.88746127841607,
      "lon": -76.30376257566029,
      "reportType": "pothole",
      "reportStatus": "active",
      "reportTime": "10 mins ago",
      "reportDescription": "something interesting",
    },
    {
      "title": "constant hall",
      "id": "3",
      "lat": 36.88757122942166,
      "lon": -76.3052626931859,
      "reportType": "missing signage",
      "reportStatus": "active",
      "reportTime": "50 mins ago",
      "reportDescription": "something interesting",
    },
  ];
  static int get size => list.length;
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng initialLocation = const LatLng(36.8855, -76.3058);
  static const CameraPosition InitialCameraPostition =
      CameraPosition(target: initialLocation, zoom: 17.0, tilt: 0, bearing: 0);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  List<Marker> allMarkers = [];

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/marker_small.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  markerBuilder(int index, BuildContext context) {
    var temp = MarkersList.list[index];
    return Marker(
        markerId: MarkerId(temp['id']),
        draggable: false,
        icon: markerIcon,
        position: LatLng(
          temp['lat'],
          temp['lon'],
        ),
        infoWindow: InfoWindow(
            title: temp["title"],
            onTap: (){
              context.goNamed("report_info",
                  queryParams: {
                    'p1': temp['reportType'],
                    'p2': temp['reportStatus'],
                    'p3': temp['reportTime'],
                    'p4': temp['reportDescription']
                  });
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      //Edits where you can start a drag motion to open the side bar
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.05,
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: GoogleMap(
          initialCameraPosition: InitialCameraPostition,
          markers: Set.from(allMarkers),
          onMapCreated: (GoogleMapController controller) {
            // mapController = controller;
            // controller.showMarkerInfoWindow(MarkerId("yourMarkerIdHere"));

            setState(() {
              for (var i = 0; i < MarkersList.size; i++) {
                allMarkers.add(markerBuilder(i, context));
              }
            });
          },
          onTap: (tap_latLng) {
            context.push("/report", extra: tap_latLng);
            /*
            // print('${latLng.latitude}, ${latLng.longitude}'); // prints lng and lat
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ReportScreen(passed_location: tap_latLng)));*/
          }),

      /**
       * Button Location to submit a report. When selected the button
       * is to open the report screen and transfer user to that screen.
       */
      floatingActionButton: SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        child: FloatingActionButton.extended(
          icon: const Icon(Icons.report),
          label: const Text('Report Unsafe Condition'),
          onPressed: () => {
            context.push('/report'),
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
