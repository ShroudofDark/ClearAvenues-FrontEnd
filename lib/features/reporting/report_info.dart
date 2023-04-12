import 'package:flutter/material.dart';

class ReportInfoScreen extends StatefulWidget {
  String? ReportType ;
  String? ReportStatus;
  String? ReportTime;
  String? ReportDecription;
  // String? id1;
  // String? id2;

  ReportInfoScreen({super.key, this.ReportType, this.ReportStatus, this.ReportTime, this.ReportDecription});

  @override
  State<ReportInfoScreen> createState() => _ReportInfoScreenState();
}

class _ReportInfoScreenState extends State<ReportInfoScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Info'),
      ),
      body: Center(
        child: Text(
          "Report Type: ${widget.ReportType}\n"
              "Report Status: ${widget.ReportStatus}\n"
              "Report Time: ${widget.ReportTime}\n"
              "Report Description: ${widget.ReportDecription}\n",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ),
    );
  }
}