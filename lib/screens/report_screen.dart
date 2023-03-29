import 'package:clear_avenues/widgets/my_scaffold.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key, this.coordinates = const LatLng(0, 0)})
      : super(key: key);
  final LatLng coordinates;
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class UnsafeCondition {
  const UnsafeCondition(this.displayName, this.name, this.img);
  final String displayName;
  final String name;
  final Image img;
}

class _ReportScreenState extends State<ReportScreen> {
  bool isDriving = false;

  //Allows for Images and Other Customization
  List<UnsafeCondition> conditions = [
    UnsafeCondition(
        "Debris", "debris", Image.asset("assets/TrafficCone64.png")),
    UnsafeCondition(
        "Flooding", "flooding", Image.asset("assets/TrafficCone64.png")),
    UnsafeCondition("Missing Sign", "missing_signage",
        Image.asset("assets/MissingSign64.png")),
    UnsafeCondition(
        "Pothole", "pothole", Image.asset("assets/TrafficCone64.png")),
    UnsafeCondition("Obstructed Sign", "obstructed_sign",
        Image.asset("assets/TrafficCone64.png")),
    UnsafeCondition("Vehicular Related", "vehicle_accident",
        Image.asset("assets/TrafficCone64.png")),
    UnsafeCondition("Other", "other", Image.asset("assets/TrafficCone64.png")),
  ];

  // If you initialize this as UnsafeCondition, you need to mark it as late.
  // If you do that and someone opens the report page it will throw an error page at you.
  // Keeping it as var seems to be the cleanest method so far.
  UnsafeCondition? selectedCondition;

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
                Image.asset(
                    "assets/gmaps_placeholder.webp"), // TODO: replace image with map preview centered around selected area
                TextField(
                  // Will be changed later
                  controller: _controller
                    ..text = widget.coordinates.latitude.toString() +
                        ", " +
                        widget.coordinates.longitude.toString(),
                  //"${widget.passed_location?.longitude} ${widget.passed_location?.latitude}",
                  onSubmitted: null,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Enter a location"),
                      filled: true,
                      fillColor: Colors.white),
                ),
              ],
            ),

            /* New dropdown button for unsafe condition types.
             * Allows for images to act as icons to work alongside the text.
             */
            DropdownButton(
              //Decorations
              hint: const Text("Choose Unsafe Condition"),
              isExpanded: true,
              itemHeight: 125, //Changes internal height of box
              menuMaxHeight: MediaQuery.of(context).size.height * 0.75,
              iconSize: 48, //Adjust dropdown arrow size
              borderRadius: BorderRadius.circular(10),
              //Wrapped in Container to allow for background coloring
              icon: Container(
                color: Colors.cyan[400],
                //The padding size is different here, but matches up size wise with the item
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
              ),
              elevation: 16,
              focusColor: Colors.green,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              underline: Container(
                height: 4,
                color: Colors.green,
              ),

              //Value Info
              value: selectedCondition,
              onChanged: (value) {
                setState(() {
                  selectedCondition = value!;
                });
              },

              items: conditions.map((UnsafeCondition condition) {
                return DropdownMenuItem(
                  value: condition,
                  child: Container(
                    //Highlights already selected value
                    color: selectedCondition == condition
                        ? Colors.cyan[200]
                        : null,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        condition.img,
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          condition.displayName,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const TextField(
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(labelText: "Enter Description"),
              maxLines: 5,
            ),
            const ElevatedButton(
              onPressed: _onPressSubmit,
              child: Text('Submit'),
            ),
            const Icon(size: 60, Icons.camera_alt),
          ],
        ),
      ),
    );
  }
}

void _onPressSubmit() async {}
