import 'package:clear_avenues/screens/about_screen.dart';
import 'package:clear_avenues/screens/analysis_screen.dart';
import 'package:clear_avenues/screens/bug_screen.dart';
import 'package:clear_avenues/screens/google_maps_screen.dart';
import 'package:clear_avenues/screens/help_screen.dart';
import 'package:clear_avenues/screens/notification_screen.dart';
import 'package:clear_avenues/screens/register_screen.dart';
import 'package:clear_avenues/screens/view_history.dart';
import 'package:clear_avenues/screens/setting_screen.dart';
import 'package:clear_avenues/screens/view_organization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    GoRoute(path: '/report', builder: (context, state) => const ReportScreen(passed_location: LatLng(0.0,0.0))), // report text default to 0.0,0.0 when not entering through map screen tap
    GoRoute(path: '/map', builder: (context, state) => const MapScreen()),
    GoRoute(path: '/setting', builder: (context, state) => const SettingScreen()),
    GoRoute(path: '/view_organization', builder: (context, state) => const ViewOrganization()),
    GoRoute(path: '/analysis', builder: (context, state) => const AnalysisScreen()),
    GoRoute(path: '/notification', builder: (context, state) => const NotificationScreen()),
    GoRoute(path: '/help', builder: (context, state) => const HelpScreen()),
    GoRoute(path: '/bug_report', builder: (context, state) => const BugReportScreen()),
    GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
  ]);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        // You can add/adjust other parameters to modify it to your liking
        primarySwatch: Colors.green,

      ),
      routerConfig: _router
      //routerConfig: _router
    );
  }
}

