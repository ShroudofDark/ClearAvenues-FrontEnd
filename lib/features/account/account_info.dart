import 'package:clear_avenues/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountInfoScreen extends ConsumerStatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  ConsumerState<AccountInfoScreen> createState() => _AccountInfoScreen();
}

class _AccountInfoScreen extends ConsumerState<AccountInfoScreen> {

  TextEditingController emailControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
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
            Text(
              "${user.email}",
              style: const TextStyle(
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
            Text(
              "${user.accountType}",
              style: const TextStyle(
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
            TextField(
              controller: emailControl,
              decoration: const InputDecoration(
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
            TextField(
              controller: passwordControl,
              decoration: const InputDecoration(
                hintText: 'New Password',
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                ref.read(userProvider.notifier).logout();
                context.pop();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
