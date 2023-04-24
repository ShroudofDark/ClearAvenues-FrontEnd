import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../providers.dart';

class NotificationWidget extends StatelessWidget {
  final String body;
  final String title;
  const NotificationWidget({Key? key, required this.body, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          children: [
            Text(body),
          ],
        ),
      ),
    );
  }
}

class ReportNotificationWidget extends ConsumerWidget {
  final String title;
  final int index;
  final LatLng locationToReport;
  final String receivedTimeString;
  final String address;
  const ReportNotificationWidget(
      {Key? key,
      required this.title,
      required this.index,
      required this.locationToReport,
      required this.receivedTimeString,
      required this.address})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    ref
                        .read(savedNotificationsProvider.notifier)
                        .removeNotification(index);
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
                const Text(
                  "Click Button To Create Report At:",
                  style: TextStyle(
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
                const SizedBox(
                  height: 10,
                ),
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
