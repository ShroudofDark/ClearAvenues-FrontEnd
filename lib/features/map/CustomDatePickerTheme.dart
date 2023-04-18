import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:clear_avenues/utility/notification_service.dart';

DateTime selectedTime = DateTime.now();

class MyDateTimePickerTheme extends DateTimePickerTheme {

  MyDateTimePickerTheme(BuildContext context):super(
      titleHeight: 100,
      title: Container(
        color: Colors.green,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancel',
                    style: TextStyle(fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Text('Select Reminder Time',
                  style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                TextButton(
                  onPressed: () {
                    /**
                     * At later time this data should be saved locally to build something on device
                     * to make a notification for the user.
                     */
                    //TODO set alarm / notification with selected date
                    NotificationService().addNotification(
                        'Notification Title',
                        'Notification Body',
                        selectedTime.millisecondsSinceEpoch,
                        'testing',
                    );
                    context.pop();
                  },
                  child: const Text('Done',
                    style: TextStyle(fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const Padding( padding: EdgeInsets.symmetric(vertical: 8.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('Day',
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                Text('Hour',
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                Text('Minute',
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)
                ),
              ],
            ),
            const Padding( padding: EdgeInsets.symmetric(vertical: 8.0),),
          ],
        ),
      ),

  );
}