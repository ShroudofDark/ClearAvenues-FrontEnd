import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Default Values Stored for Sake of Demo
MyNotification exampleNotification = MyNotification();
MyNotification exampleReminderNotification =
    ReminderNotification(const LatLng(36.886270, -76.309725), DateTime.now());
MyNotification exampleUnsafeNotification =
    UnsafeNotification(const LatLng(36.88538, -76.31266),DateTime.now(),"Missing Sign");
MyNotification exampleStatusNotification =
    StatusNotification(const LatLng(36.88704, -76.31275),DateTime.now(),
        "The City of Norfolk","Fire in Process of Being Put Out");

List<MyNotification> defaultList = [
  exampleReminderNotification,
  exampleUnsafeNotification,
  exampleStatusNotification
];

void removeNotification(int index) {
  defaultList.removeAt(index);
}

void createReminderNotificationDelayed(LatLng location, int timeDelaySeconds) async {
  debugPrint(timeDelaySeconds.toString());
  Timer(Duration(seconds: timeDelaySeconds), () {
    MyNotification exampleTimer = ReminderNotification(location, DateTime.now());
    defaultList.add(exampleTimer);
  });
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
  String receivedTimeString = "Default";

  ReminderNotification(LatLng reminderLoc, DateTime receivedTime) {
    locationToReport = reminderLoc;
    receivedTimeString = receivedTime.toString().substring(0,16);
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
          subtitle: Text("Received On: $receivedTimeString"),
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
  LatLng? unsafeConditionLocation;
  String unsafeConditionType = "Default Type";
  String address = "Default Location";
  String receivedTimeString = "Default Time";

  UnsafeNotification(LatLng conditionLoc, DateTime receivedTime, String conditionType) {
    unsafeConditionLocation = conditionLoc;
    receivedTimeString = receivedTime.toString().substring(0,16);
    unsafeConditionType = conditionType;
    setAddress();
    title = "Nearby Unsafe Condition";
    body = "$unsafeConditionType reported at:";
  }

  setAddress() async {
    List<Placemark> location = await placemarkFromCoordinates(
        unsafeConditionLocation!.latitude, unsafeConditionLocation!.longitude);
    address =
    '${location[0].street}, ${location[0].locality}, ${location[0].administrativeArea} ${location[0].postalCode}';
  }

  @override
  Widget displayNotification(int index, BuildContext context) {
    return Container(
      color: Colors.red[800],
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
          subtitle: Text("Received On: $receivedTimeString"),
          controlAffinity: ListTileControlAffinity.leading,
          children: [
            Column(
              children: [
                Divider(
                  thickness: 2,
                  color: Colors.red[300],
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
                      //TODO should I push this to a report info screen or just the map?
                    },
                    child: const Text("View Condition")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatusNotification extends MyNotification {
  LatLng? reportLocation;
  String address = "Default Location";
  String receivedTimeString = "Default Time";
  String statusUpdater = "Default Name";
  String updatedStatus = "Default Status";

  //Passing in a name as it makes it easier to 'store' who did the update when its displayed
  StatusNotification(LatLng reportLoc, DateTime receivedTime, String updater, String newStatus) {
    reportLocation = reportLoc;
    receivedTimeString = receivedTime.toString().substring(0,16);
    statusUpdater = updater;
    updatedStatus = newStatus;
    setAddress();
    title = "Status Update to Report";
    body = "$statusUpdater updated report at:";
  }

  setAddress() async {
    List<Placemark> location = await placemarkFromCoordinates(
        reportLocation!.latitude, reportLocation!.longitude);
    address =
    '${location[0].street}, ${location[0].locality}, ${location[0].administrativeArea} ${location[0].postalCode}';
  }

  @override
  Widget displayNotification(int index, BuildContext context) {
    return Container(
      color: Colors.purple[800],
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
          subtitle: Text("Received On: $receivedTimeString"),
          controlAffinity: ListTileControlAffinity.leading,
          children: [
            Column(
              children: [
                Divider(
                  thickness: 2,
                  color: Colors.purple[300],
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
                const SizedBox(height: 16,),
                Text(
                  "\"$updatedStatus\"",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                    onPressed: () {
                      //TODO should I push this to a report info screen or just the map?
                    },
                    child: const Text("View Report")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
