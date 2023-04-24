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

  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text(
                "${user.name}",
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
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
              Form(
                key: emailKey,
                child: TextFormField(
                  controller: emailControl,
                  decoration: const InputDecoration(
                    hintText: 'New Email Address',
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Cannot Be Empty';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if(emailKey.currentState!.validate()) {
                    debugPrint("Temp");
                    emailControl.clear();
                  }
                },
                child: const Text(
                  "Submit",
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
              Form(
                key: passwordKey,
                child: TextFormField(
                  controller: passwordControl,
                  decoration: const InputDecoration(
                    hintText: 'New Password',
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Cannot Be Empty';
                    }
                    if (passwordControl.text.length < 8) {
                      return 'Minimum of 8 Characters Required';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if(passwordKey.currentState!.validate()) {
                    debugPrint("Temp");
                    passwordControl.clear();
                  }
                },
                child: const Text(
                  "Submit",
                ),
              ),
              const SizedBox(height: 32.0),
              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(userProvider.notifier).logout();
                    context.pop();
                  },
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
