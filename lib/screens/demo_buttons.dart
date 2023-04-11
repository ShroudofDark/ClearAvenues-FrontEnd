import 'package:flutter/material.dart';
import '../utility/demo_assist.dart';

class DemoButtonScreen extends StatefulWidget {
  const DemoButtonScreen({super.key});

  @override
  State<DemoButtonScreen> createState() => _DemoButtonScreen();
}

class _DemoButtonScreen extends State<DemoButtonScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Map View'),
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
                    ElevatedButton(
                        onPressed: setStartLocation(37.353407,-79.275895),
                        child: const Text("Forest, VA"),
                    ),
                    ElevatedButton(
                      onPressed: setStartLocation(37.353407,-79.275895),
                      child: const Text("other"),
                    ),
                    ElevatedButton(
                      onPressed: setStartLocation(37.353407,-79.275895),
                      child: const Text("other"),
                    ),
                  ],
                ),
                //TODO submit coordinates box
              ],
            ),
          ),
        ),
    );
  }
}