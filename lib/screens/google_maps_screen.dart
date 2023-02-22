import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:clear_avenues/widgets/navigation_bar.dart';


class AppConstant {
  static List<Map<String, dynamic>> list = [
    {"title": "web center", "id": "1", "lat": 36.88666959507779, "lon": -76.306716388986},
    {"title": "dragas hall", "id": "2", "lat": 36.88746127841607, "lon": -76.30376257566029},
    {"title": "constant hall", "id": "3", "lat": 36.88757122942166, "lon": -76.3052626931859},
  ];
}

//-----------PLEASE READ----------------//
//-------------------------------------//
// This was created just for the mockup. The real google maps integration will
// need to be written later
class SimpleMap extends StatefulWidget {
  const SimpleMap({super.key});

  @override
  State<SimpleMap> createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMap> {
  static const LatLng _kMapCenter = LatLng(36.8855, -76.3058);
  static const CameraPosition _kInitialPosition = CameraPosition(target: _kMapCenter, zoom: 17.0, tilt: 0, bearing: 0);

  Completer<GoogleMapController> _controller = Completer();
  Iterable markers = [];

  final Iterable _markers = Iterable.generate(AppConstant.list.length, (index) {
    return Marker(
        markerId: MarkerId(AppConstant.list[index]['id']),
        position: LatLng(
          AppConstant.list[index]['lat'],
          AppConstant.list[index]['lon'],
        ),
        infoWindow: InfoWindow(title: AppConstant.list[index]["title"])
    );
  });

  @override
  void initState() {
    setState(() {
      markers = _markers;
    });
    super.initState();
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
        mapType: MapType.hybrid,
        initialCameraPosition: _kInitialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.from(markers),
      ),
    );
  }
}