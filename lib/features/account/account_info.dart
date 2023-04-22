import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Email Address',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const Text(
              //TODO: logic to display email Address
              'user@example.com',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Account Type',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const Text(
              //TODO: logic to display the Account Type
              'Premium',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Change Email Address',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'New Email Address',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Change Password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'New Password',
              ),
            ),

            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Takes the user to the login screen
                context.push('/login');
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }


}
