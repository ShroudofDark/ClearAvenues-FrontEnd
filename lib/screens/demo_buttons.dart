import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utility/demo_assist.dart';

class DemoButtonScreen extends StatefulWidget {
  const DemoButtonScreen({super.key});

  @override
  State<DemoButtonScreen> createState() => _DemoButtonScreen();
}

class _DemoButtonScreen extends State<DemoButtonScreen> {
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();
  final locKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Buttons'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          child: Column(
            children: [
              const Text("Set Demo Mode"),
              Switch(
                value: isDemoing,
                onChanged: (value) => setState(() => isDemoing = value),
              ),
              const Text("Change Current Location"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () {
                      setStartLocation(37.353407, -79.275895);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.greenAccent;
                        }
                        return Colors.green;
                      }),
                    ),
                    child: const Text(
                      "Forest, VA",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      setStartLocation(36.8855, -76.3058);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.greenAccent;
                        }
                        return Colors.green;
                      }),
                    ),
                    child: const Text(
                      "ODU, VA",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      setStartLocation(42.721572, -78.826944);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.greenAccent;
                        }
                        return Colors.green;
                      }),
                    ),
                    child: const Text(
                      "Hamburg, NY",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Type Location"),
              ),
              Form(
                key: locKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: latController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[\d.]")),
                      ],
                      decoration: const InputDecoration(
                          label: Text("Latitude"),
                          hintText: "Insert Latitude",
                          icon: Icon(Icons.my_location_rounded)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Make sure to fill out coordinate';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: lngController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[\d.]")),
                      ],
                      decoration: const InputDecoration(
                          label: Text("Longitude"),
                          hintText: "Insert Longitude",
                          icon: Icon(Icons.my_location_rounded)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Make sure to fill out coordinate';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FilledButton(
                      onPressed: () {
                        if (locKey.currentState!.validate()) {
                          double lat = double.parse(latController.text);
                          double lng = double.parse(lngController.text);
                          setStartLocation(lat, lng);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.greenAccent;
                          }
                          return Colors.green;
                        }),
                      ),
                      child: const Text(
                        "Change",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //TODO - maybe - button to enable moving current location on map as if actively driving or something

              //TODO Quick Button To Swap Account Types (So We Don't Have To Relogin)

              //TODO Quick Button To Add A Bunch of Fake Reports around "current location"
            ],
          ),
        ),
      ),
    );
  }
}
