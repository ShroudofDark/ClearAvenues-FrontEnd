import 'package:clear_avenues/widgets/my_scaffold.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key, required this.passed_location}) : super(key: key);
  final LatLng passed_location;
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

  final TextEditingController _controller = TextEditingController();

  // static LatLng loc = LatLng(1.0,1.0);
  // static LatLng? loc = passed_location;
  // static String s = "${loc?.longitude} ${loc?.latitude}";

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Stack(
              children: [
                Image.asset("assets/gmaps_placeholder.webp"), // TODO: replace image with map preview centered around selected area
                TextField(
                  controller: _controller..text = "${widget.passed_location?.longitude} ${widget.passed_location?.latitude}",
                    onSubmitted: null,
                  decoration: const InputDecoration(
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
