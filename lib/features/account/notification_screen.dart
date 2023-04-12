import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  //TODO

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, String>> _notifications = [ {"title": "Alert of Nearby Unsafe Condition",
    "details": "Details about the Alert of Nearby Unsafe Condition"},
    {"title": "Reminder To Report",
      "details": "Details about the Reminder To Report"},
    {"title": "Invitation To Organization",
      "details": "Details about the Invitation To Organization" },
    {"title": "Status Update on Report",
      "details": "Details about the Status Update on Report"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
        ),
        body: ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
                title: Text(_notifications[index]["title"]!),
                children: <Widget>[
                Container(
                     padding: const EdgeInsets.all(16.0),
                     child: Text(_notifications[index]["details"]!),
            ),
                Container(
                     padding: const EdgeInsets.all(16.0),
                     child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {setState(() {
                            _notifications.removeAt(index);
                            });
                          },
                        ),
                      ],
                     ),
                ),
            ],
        );
        },
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.delete),
            onPressed: () {
            setState(() {
            _notifications.clear();
            });
        },
        ),
    );
  }
}