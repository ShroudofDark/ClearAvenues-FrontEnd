import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ReportInfoScreen extends StatefulWidget {
  final String? reportType;
  final String? reportStatus;
  final String? reportTime;
  final String? reportDecription;
  final String? reportLat;
  final String? reportLon;


  const ReportInfoScreen({super.key, this.reportType, this.reportStatus,
    this.reportTime, this.reportDecription, this.reportLat, this.reportLon});

  // get coordinates => {double.tryParse(ReportLat ?? ''), double.tryParse(ReportLon ?? '')};

  @override
  State<ReportInfoScreen> createState() => _ReportInfoScreenState();
}

class _ReportInfoScreenState extends State<ReportInfoScreen> {
  String? _address;

  List<String> reportStatusOptions = ["Active", "Inactive"];

  @override
  void initState() {
    super.initState();

    //Set Display Text when screen starts
    var tempLat = double.tryParse(widget.reportLat as String);
    var tempLon = double.tryParse(widget.reportLon as String);
    _getAddressFromCoords(tempLat as double, tempLon as double);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Info'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 24.0),
            RichText(
              text: TextSpan(
                text: "Report Type: ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: "${widget.reportType}\n",
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            RichText(
              text: TextSpan(
                text: "Report Status: ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: "${widget.reportStatus}\n",
                    style: TextStyle(
                      fontSize: 16,
                        color: (widget.reportStatus == reportStatusOptions[0]) ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            RichText(
              text: TextSpan(
                text: "Report Time: ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: "${widget.reportTime}\n",
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            RichText(
              text: TextSpan(
                text: "Report Latitude: ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: "${widget.reportLat}\n",
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            RichText(
              text: TextSpan(
                text: "Report Longitude: ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: "${widget.reportLon}\n",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            RichText(
              text: TextSpan(
                text: "Report Location: \n",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: "$_address\n",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            RichText(
              text: TextSpan(
                text: "Report ReportDecription: \n",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: "${widget.reportDecription}\n",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(
              color: Colors.black,
              thickness: 1,
              height: 16,
              indent: 16,
              endIndent: 16,
            ),
            const SizedBox(height: 24.0),
            Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Is this issue still here?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ]
            ),

            Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    debugPrint("yes");
                    // send to info database
                  },
                  child: const Text('Yes'),
                ),
                const SizedBox(width: 16), // Add some spacing between the buttons
                ElevatedButton(
                  onPressed: () {
                    debugPrint("no");
                    // send to info database
                  },
                  child: const Text('no'),
                ),
              ]
            ),
          ], //column children
        ),
      )
    );
  }

  Future<String> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      String address = '${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}';
      return address;
    } catch (e) {
      return 'Could not get address';
    }
  }

  Future<void> _getAddressFromCoords(double tempLat, double tempLon) async {
    await placemarkFromCoordinates(tempLat, tempLon)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _address =
        '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
      });
    });
  }

}