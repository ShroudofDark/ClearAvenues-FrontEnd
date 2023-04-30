import 'package:clear_avenues/models/Notification.dart';
import 'package:clear_avenues/providers.dart';
import 'package:clear_avenues/utility/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

DateTime selectedTime = DateTime.now();

class MyDateTimePickerTheme extends DateTimePickerTheme {
  MyDateTimePickerTheme(BuildContext context, LatLng coords)
      : super(
          titleHeight: 100,
          title: Container(
            color: Colors.green,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        return TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'Select Reminder Time',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Consumer(builder: (context, ref, child) {
                      return TextButton(
                        onPressed: () {
                          String notificationBody =
                              "${ref.watch(userProvider).name} remember to report! View information under Notifications.";
                          NotificationService().addNotification(
                            'Reminder to Report',
                            notificationBody,
                            selectedTime.millisecondsSinceEpoch,
                            'ReportLater',
                          );

                          ref
                              .watch(savedNotificationsProvider.notifier)
                              .addNotification(MyNotification(
                                "Reminder to Report",
                                coords,
                                DateTime.now().toString().substring(0, 16),
                              ));
                          context.pop();
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text(
                      'Day',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'Hour',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text('Minute',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                ),
              ],
            ),
          ),
        );
}
