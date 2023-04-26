import 'package:clear_avenues/features/reporting/provider.dart';
import 'package:clear_avenues/models/Report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService extends ProviderObserver {
  @override
  Future<void> didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) async {
    debugPrint("Provider updated: ${container.read(provider)}");
    // If a user's report receives a status update
    if (provider == userReportProvider) {
      if (previousValue! is AsyncData<List<Report>> ||
          newValue! is AsyncData<List<Report>>) {
        return;
      }
      var prev = (previousValue as AsyncData<List<Report>>).value;
      var newVal = (newValue as AsyncData<List<Report>>).value;
      List<Report> differences = [];

      // Find which reports were updates and store them in differences
      for (int i = 0; i < newVal.length; i++) {
        if (prev[i].reportStatus != newVal[i].reportStatus) {
          differences.add(newVal[i]);
        }
        for (final report in differences) {
          timezone_data.initializeTimeZones();
          await flutterLocalNotificationsPlugin.show(
              0,
              "Your report has received a status update",
              report.reportComment,
              const NotificationDetails(
                  android: AndroidNotificationDetails(
                "Status Update",
                "Status Update",
                playSound: true,
                priority: Priority.high,
                importance: Importance.high,
              )));
        }
      }
    }
  }

  NotificationService();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin
        .initialize(initializationSettings,
            onDidReceiveNotificationResponse:
                (NotificationResponse response) {})
        .then((_) {
      debugPrint('setupPlugin: Notification Set Up Complete');
    }).catchError((Object error) {
      debugPrint('Notification Error: $error');
    });
  }

  void addNotification(
      String title, String body, int endTime, String channel) async {
    timezone_data.initializeTimeZones();
    final tz.TZDateTime scheduleTime =
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);
    final AndroidNotificationDetails androidDetail = AndroidNotificationDetails(
      channel,
      channel,
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
    );
    final NotificationDetails noticeDetail =
        NotificationDetails(android: androidDetail);
    //Figure out how to pass an ID based on whats currently in notification queue
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

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }
}
