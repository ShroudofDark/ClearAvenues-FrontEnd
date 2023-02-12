import 'package:flutter/material.dart';

class  ViewOrganization extends StatefulWidget {
  const ViewOrganization({Key? key}) : super(key: key);
  //TODO
  /* This is the layout for the organization screen.
  it still needs to be improved.
   */
  @override
  State<ViewOrganization> createState() => _ViewOrganizationState();
}

class _ViewOrganizationState extends State<ViewOrganization> {
  String organizationName = "My Organization";
  List<String> currentUsers = ["User 1", "User 2", "User 3"];
  List<String> pendingUsers = ["User 4", "User 5"];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Organization'),
        ),
      body: Column(
          children: [
          Container(
          padding: const EdgeInsets.all(16.0),
              child: Text(
              organizationName,
              style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              ),
          ),
          ),
           Expanded(
              child: ListView(
              children: [
                  ListTile(
                      title: const Text("Current Users"),
                      subtitle: Text(currentUsers.join(", ")),
                  ),
                  ListTile(
                      title: const Text("Pending Users"),
                      subtitle: Text(pendingUsers.join(", ")),
                  ),
              ],
              ),
            ),
            Container(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                "${currentUsers.length + pendingUsers.length} / ${currentUsers.length + pendingUsers.length + 10}",
                style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
            ),
            ),
            ),
      ]

      )
    );
  }
}
