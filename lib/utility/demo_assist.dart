/// This file will contain a lot of data that can be passed between screens easily
/// Global variables are usually a no-no, but this is a quick and dirty way to get this
/// set up

import 'package:google_maps_flutter/google_maps_flutter.dart';

bool isDemoing = false;
LatLng newCurrLoc = const LatLng(0,0);


setStartLocation(double latitude, double longitude) {
  newCurrLoc = LatLng(latitude, longitude);
}
