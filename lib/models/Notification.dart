import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Default Values Stored for Sake of Demo
//MyNotification exampleNotification = MyNotification();
//MyNotification exampleReminderNotification =
//    ReminderNotification(const LatLng(36.886270, -76.309725), DateTime.now());
//MyNotification exampleUnsafeNotification = UnsafeNotification();
//MyNotification exampleStatusNotification = StatusNotification();

//List<MyNotification> defaultList = [
// NotificationWidget("Example Notification", "Default title"),
//exampleUnsafeNotification,
// exampleStatusNotification
//];

class MyNotification {
  final String title;
  final LatLng locationToReport;
  final String receivedTimeString;
  String address;
  MyNotification([
    this.title = "Default Notification To Report",
    this.locationToReport = const LatLng(36.886270, -76.309725),
    this.receivedTimeString = "January 1st, 2000",
    this.address = "France House, Norfolk, Virginia 23529",
  ]) {
    getAddress(locationToReport);
  }

  void getAddress(LatLng coords) async {
    List<Placemark> location =
        await placemarkFromCoordinates(coords.latitude, coords.longitude);
    address =
        '${location[0].street}, ${location[0].locality}, ${location[0].administrativeArea} ${location[0].postalCode}';
  }
}
