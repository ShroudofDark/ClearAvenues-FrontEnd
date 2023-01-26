import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool isDriving = true;
  static const List<String> list = <String>[
    'Accident',
    'Road Sign',
    'Flooding',
    'Pothole'
  ];
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  _showDialog(context);
                  dropdownValue = value!;
                });
              },
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: 'Accident',
                  child: Center(child: Text('Flooding')),
                ),
                DropdownMenuItem(
                  value: 'Pothole',
                  child: Center(child: Text('Pothole')),
                ),
                DropdownMenuItem(
                  value: 'Road Sign',
                  child: Center(child: Text('Blocked Sign')),
                ),
                DropdownMenuItem(
                  value: 'Blind Turn',
                  child: Center(child: Text('Blind Turn')),
                ),
                DropdownMenuItem(
                  value: 'Slick Roads',
                  child: Center(child: Text('Slick Roads')),
                ),
              ]),
          const TextField(
            decoration: InputDecoration(labelText: "Description"),
            maxLines: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Icon(
                size: 60,
                Icons.camera_alt
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Alert!"),
            content:
                new Text("Unsafe Road Condition Nearby. Proceed With Caution"),
            actions: []);
      },
    );
  }
}
