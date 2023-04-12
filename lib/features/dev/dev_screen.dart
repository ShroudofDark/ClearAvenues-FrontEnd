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
              child: const Text('View History')),
          ElevatedButton(
              onPressed: () => context.push('/map'),
              child: const Text('Map Screen')),
          ElevatedButton(
              onPressed: () => context.push('/setting'),
              child: const Text('Setting Screen')),
          ElevatedButton(
              onPressed: () => context.push('/view_organization'),
              child: const Text('View Organization')),
          ElevatedButton(
              onPressed: () => context.push('/analysis'),
              child: const Text('Analysis Screen')),
          ElevatedButton(
              onPressed: () => context.push('/notification'),
              child: const Text('Notification Screen')),
          ElevatedButton(
              //onPressed: () => context.push('/report_info'),
              onPressed: () => context.pushNamed("report_info",
                  queryParams: {
                    'p1': 'param1',
                    'p2': 'param2',
                    'p3': 'param3',
                    'p4': 'param4'
              }),
              child: const Text('Report Info Screen')),
        ],
      ),
    ));
  }
}
