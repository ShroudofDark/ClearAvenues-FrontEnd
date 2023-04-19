import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Default Values Stored for Sake of Demo
MyNotification exampleNotification = MyNotification();
MyNotification exampleReminderNotification =
    ReminderNotification(const LatLng(36.886270, -76.309725));
MyNotification exampleUnsafeNotification = UnsafeNotification();
MyNotification exampleStatusNotification = StatusNotification();

List<MyNotification> defaultList = [
  exampleReminderNotification,
  exampleUnsafeNotification,
  exampleStatusNotification
];

void removeNotification(int index) {
  defaultList.removeAt(index);
}

class MyNotification {
  String? title;
  String? body;

  MyNotification() {
    title = "Default Type";
    body = "Default Body";
  }

  Widget displayNotification(int index, BuildContext context) {
    return Container(
      color: Colors.purple[300],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ExpansionTile(
          iconColor: Colors.white,
          textColor: Colors.white,
          collapsedIconColor: Colors.white,
          collapsedTextColor: Colors.white,
          title: Text(
            title!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          children: [
            Text(body!),
          ],
        ),
      ),
    );
  }
}

class ReminderNotification extends MyNotification {
  LatLng? locationToReport;
  String address = "Default Location";

  ReminderNotification(LatLng reminderLoc) {
    locationToReport = reminderLoc;
    setAddress();
    title = "Reminder to Report";
    body = "Click Button to Create Report At:";
  }

  setAddress() async {
    List<Placemark> location = await placemarkFromCoordinates(
        locationToReport!.latitude, locationToReport!.longitude);
    address =
        '${location[0].street}, ${location[0].locality}, ${location[0].administrativeArea} ${location[0].postalCode}';
  }

  @override
  Widget displayNotification(int index, BuildContext context) {
    return Container(
      color: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ExpansionTile(
          iconColor: Colors.white,
          textColor: Colors.white,
          collapsedIconColor: Colors.white,
          collapsedTextColor: Colors.white,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    removeNotification(index);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.delete),
                      Text("Delete"),
                    ],
                  ))
            ],
          ),
          subtitle: const Text("Received On: Default"),
          controlAffinity: ListTileControlAffinity.leading,
          children: [
            Column(
              children: [
                Divider(
                  thickness: 2,
                  color: Colors.cyan[300],
                ),
                Text(
                  body!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  address,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                    onPressed: () {
                      context.push('/report', extra: locationToReport);
                    },
                    child: const Text("Create Report")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UnsafeNotification extends MyNotification {
  @override
  Widget displayNotification(int index, BuildContext context) {
    return const Text("Default Unsafe Condition");
  }
}

class StatusNotification extends MyNotification {
  @override
  Widget displayNotification(int index, BuildContext context) {
    return const Text("Default Status Update");
  }
}
