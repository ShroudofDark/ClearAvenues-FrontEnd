import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'CustomDatePickerTheme.dart';

class ReportMethodDialog extends StatelessWidget {
  const ReportMethodDialog( this.coords, {Key? key}) : super(key: key);
  final LatLng coords;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Choose"),
      content: const Text("Would you like to submit a report now?"),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            context.push("/report", extra: coords);
          },
          child: const Text("Submit"),
        ),
        TextButton(
          onPressed: () {
            context.pop();
            //Limits user from picking time before current time
            DateTime dateLimitMin =
                DateTime.now().copyWith(minute: DateTime.now().minute + 1);
            //Limit user from picking something so far out that it makes no sense
            DateTime dateLimitMax =
                DateTime.now().copyWith(day: DateTime.now().day + 5);
            //Set global variable for CustomDatePicker
            selectedTime = dateLimitMin;
            DatePicker.showDatePicker(context,
                dateFormat: 'dd HH:mm',
                initialDateTime: dateLimitMin,
                minDateTime: dateLimitMin,
                maxDateTime: dateLimitMax,
                onMonthChangeStartWithFirstDate: true,
                onChange: (dateTime, List<int> index) {selectedTime = dateTime;},
                pickerTheme:
                    MyDateTimePickerTheme(context, coords));
            },
          child: const Text("Remind Me Later"),
        ),
        TextButton(
          onPressed: () => context.pop(),
          child: const Text("Close"),
        )
      ],
    );
  }
}
