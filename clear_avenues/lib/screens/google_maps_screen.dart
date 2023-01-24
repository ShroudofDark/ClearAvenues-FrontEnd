import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  static const LatLng _kMapCenter =
      LatLng(36.8853, 76.3059);

  static const CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: const GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kInitialPosition,
      ),
    );
  }
}
