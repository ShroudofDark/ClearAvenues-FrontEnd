import 'package:clear_avenues/widgets/my_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DevScreen extends StatelessWidget {
  const DevScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Center(
      child: ListView(
        children: [
          ElevatedButton(
              onPressed: () => context.push('/login'),
              child: const Text('Login Screen')),
          ElevatedButton(
              onPressed: () => context.push('/register'),
              child: const Text('Register Screen')),
          ElevatedButton(
              onPressed: () => context.push('/report'),
              child: const Text('Report Screen')),
          ElevatedButton(
              onPressed: () => context.push('/view_history'),
              child: const Text('View History'))
        ],
      ),
    ));
  }
}
