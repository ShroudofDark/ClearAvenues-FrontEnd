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
  final String name = "City of Norfolk";
  final String phone = "123-456-7890";
  final String email = "contact@norfolkva.org";
  final List<String> invitedUsers = [];
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = "";

  void _inviteUser() {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      return;
    }
    if (invitedUsers.contains(email)) {
      setState(() {
        _errorMessage = "$email is already invited";
      });
    } else {
      setState(() {
        invitedUsers.add(email);
        _errorMessage = "";
      });
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Organization"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              "Phone: $phone",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Email: $email",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Invited Users:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Column(
              children: invitedUsers
                  .map(
                    (user) => ListTile(
                  title: Text(user),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        invitedUsers.remove(user);
                      });
                    },
                  ),
                ),
              )
                  .toList(),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Enter email address to invite",
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _inviteUser,
                  child: const Text("Invite"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}