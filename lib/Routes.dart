import 'package:clear_avenues/screens/about_screen.dart';
import 'package:clear_avenues/screens/analysis_screen.dart';
import 'package:clear_avenues/screens/bug_screen.dart';
import 'package:clear_avenues/screens/dev_screen.dart';
import 'package:clear_avenues/screens/google_maps_screen.dart';
import 'package:clear_avenues/screens/help_screen.dart';
import 'package:clear_avenues/screens/login_screen.dart';
import 'package:clear_avenues/screens/notification_screen.dart';
import 'package:clear_avenues/screens/register_screen.dart';
import 'package:clear_avenues/screens/report_screen.dart';
import 'package:clear_avenues/screens/setting_screen.dart';
import 'package:clear_avenues/screens/view_history.dart';
import 'package:clear_avenues/screens/view_organization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

var routes = [
  GoRoute(path: '/', builder: (context, state) => const DevScreen()),
  GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
  GoRoute(
      path: '/register', builder: (context, state) => const RegisterScreen()),
  GoRoute(
      path: '/view_history', builder: (context, state) => const ViewHistory()),
  GoRoute(
      path: '/report',
      builder: (context, state) {
        LatLng coordinates = ((state.extra) ?? const LatLng(0, 0)) as LatLng;
        return ReportScreen(coordinates: coordinates);
      }), // report coordinates default to 0.0,0.0 when not entering through map screen tap
  GoRoute(path: '/map', builder: (context, state) => const MapScreen()),
  GoRoute(path: '/setting', builder: (context, state) => const SettingScreen()),
  GoRoute(
      path: '/view_organization',
      builder: (context, state) => const ViewOrganization()),
  GoRoute(
      path: '/analysis', builder: (context, state) => const AnalysisScreen()),
  GoRoute(
      path: '/notification',
      builder: (context, state) => const NotificationScreen()),
  GoRoute(path: '/help', builder: (context, state) => const HelpScreen()),
  GoRoute(
      path: '/bug_report',
      builder: (context, state) => const BugReportScreen()),
  GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
];
