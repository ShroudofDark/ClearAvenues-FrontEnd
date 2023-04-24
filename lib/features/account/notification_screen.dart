import 'package:clear_avenues/models/Notification.dart';
import 'package:clear_avenues/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/notification_tile.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  final List<Map<String, String>> _notifications = [
    {
      "title": "Alert of Nearby Unsafe Condition",
      "details": "Details about the Alert of Nearby Unsafe Condition"
    },
    {
      "title": "Reminder To Report",
      "details": "Details about the Reminder To Report"
    },
    {
      "title": "Invitation To Organization",
      "details": "Details about the Invitation To Organization"
    },
    {
      "title": "Status Update on Report",
      "details": "Details about the Status Update on Report"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final notis = ref.watch(savedNotificationsProvider);
    final user = ref.watch(userProvider);
    if (user.name != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
        ),
        body: ListView.builder(
            itemCount: notis.length,
            itemBuilder: (context, index) {
              final currItem = notis[index];
              return ReportNotificationWidget(
                title: currItem.title,
                address: currItem.address,
                index: index,
                receivedTimeString: currItem.receivedTimeString,
                locationToReport: currItem.locationToReport,
              );
            }),
        //TODO below button is for debugging
        floatingActionButton: ElevatedButton(
          child: const Text("Add Notification"),
          onPressed: () {
            ref
                .read(savedNotificationsProvider.notifier)
                .addNotification(MyNotification());
          },
        ),
      );
    }
    //User isn't logged in
    else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
        ),
        body: const Center(
            child: Text(
          "Login to view your Notifications",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        )),
      );
    }
  }
}
