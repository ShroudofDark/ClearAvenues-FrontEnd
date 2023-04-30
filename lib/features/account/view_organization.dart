import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class ViewOrganization extends ConsumerStatefulWidget {
  const ViewOrganization({Key? key}) : super(key: key);

  @override
  ConsumerState<ViewOrganization> createState() => _ViewOrganizationState();
}

class _ViewOrganizationState extends ConsumerState<ViewOrganization> {
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

  ///Simplified Version of Intended Use of This Screen
  ///Real-World Product would have a display for "invited users"
  ///And allow actual invites to be issued
  Widget _buildOrganizationInfo() {
    final user = ref.watch(userProvider);
    if (!(user.accountType == null || user.accountType == "standard")) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${user.name}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Email: ${user.email}",
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
              ).toList(),
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
      );
    }
    else {
      return const Center(child: Text(
          "Please Login to a Organization or Institute account to view.",
          style: TextStyle(
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
      ));
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
        child: _buildOrganizationInfo(),
      ),
    );
  }
}
