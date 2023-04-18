import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as timezone_data;


class NotificationService {
  NotificationService();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse).then((_) {
      debugPrint('setupPlugin: Notification Set Up Complete');
    }).catchError((Object error) {
      debugPrint('Notification Error: $error');
    });
  }

  void addNotification(String title, String body, int endTime, String channel) async {
    timezone_data.initializeTimeZones();
    final tz.TZDateTime scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);
    final AndroidNotificationDetails androidDetail = AndroidNotificationDetails(channel, channel);
    final NotificationDetails noticeDetail = NotificationDetails(android: androidDetail);
    const id = 0;

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduleTime,
        noticeDetail,
        uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
    );
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }
}

