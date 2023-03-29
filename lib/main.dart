import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clear_avenues/Routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GoRouter _router = GoRouter(routes: routes);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routerConfig: _router);
  }
}
