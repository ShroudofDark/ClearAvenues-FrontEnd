import 'package:clear_avenues/features/account/about_screen.dart';
import 'package:clear_avenues/features/account/account_info.dart';
import 'package:clear_avenues/features/account/bug_screen.dart';
import 'package:clear_avenues/features/account/help_screen.dart';
import 'package:clear_avenues/features/account/notification_screen.dart';
import 'package:clear_avenues/features/account/setting_screen.dart';
import 'package:clear_avenues/features/account/view_organization.dart';
import 'package:clear_avenues/features/auth/login_screen.dart';
import 'package:clear_avenues/features/auth/register_screen.dart';
import 'package:clear_avenues/features/dev/demo_buttons.dart';
import 'package:clear_avenues/features/dev/dev_screen.dart';
import 'package:clear_avenues/features/map/analysis_screen.dart';
import 'package:clear_avenues/features/map/google_maps_screen.dart';
import 'package:clear_avenues/features/reporting/report_info.dart';
import 'package:clear_avenues/features/reporting/report_screen.dart';
import 'package:clear_avenues/features/reporting/view_history.dart';
import 'package:clear_avenues/models/Association.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'features/analysis/association_info.dart';
import 'models/Report.dart';

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
      path: '/accountInfo',
      builder: (context, state) => const AccountInfoScreen()),
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
  GoRoute(
      path: '/demo_button',
      builder: (context, state) => const DemoButtonScreen()),
  GoRoute(
    name: "report_info",
    path: "/report_info",
    builder: (context, state) => ReportInfoScreen(
      report: state.extra as Report,
    ),
  ),
  GoRoute(
    name: "association_info",
    path: "/association_info",
    builder: (context, state) => AssociationInfoScreen(
      association: state.extra as Association,
    ),
  ),
];
