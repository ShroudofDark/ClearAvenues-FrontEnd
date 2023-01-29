import 'package:clear_avenues/widgets/my_scaffold.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool isDriving = true;
  static const List<String> options = <String>[
    'Accident',
    'Road Sign',
    'Flooding',
    'Pothole'
  ];
  String dropdownValue = options.first;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Stack(
              children: [
                Image.asset("assets/gmaps_placeholder.webp"),
                const TextField(
                  onSubmitted: null,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Enter a location"),
                      filled: true,
                      fillColor: Colors.white),
                ),
              ],
            ),
            DropdownButton(
                hint: const Text("Choose"),
                value: dropdownValue,
                onChanged: (value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                isExpanded: true,

              // Builds the list of item
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(child: Text(value)),
                );
              }).toList(),

                ),
            const TextField(
              decoration: InputDecoration(labelText: "Description"),
              maxLines: 5,
            ),
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Icon(
                  size: 60,
                  Icons.camera_alt
              ),
            ),
          ],
        ),
      ),
    );
  }
}
