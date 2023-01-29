import 'package:clear_avenues/screens/google_maps_screen.dart';
import 'package:clear_avenues/screens/register_screen.dart';
import 'package:clear_avenues/screens/view_history.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/report_screen.dart';
import 'screens/dev_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GoRouter _router = GoRouter(routes: [
    GoRoute(path: '/', builder: (context, state) => const DevScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/view_history', builder: (context, state) => const ViewHistory()),
    GoRoute(path: '/report', builder: (context, state) => const ReportScreen()),

  ]);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        // You can add/adjust other parameters to modify it to your liking
        primarySwatch: Colors.blue,

      ),
      routerConfig: _router
      //routerConfig: _router
    );
  }
}

