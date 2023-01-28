import 'package:flutter/material.dart';

class ViewHistory extends StatefulWidget {
  const ViewHistory({Key? key}) : super(key: key);

  @override
  State<ViewHistory> createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<ViewHistory> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Clear Avenues'),
        ),
        body:
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "My Reports",
                    style: TextStyle(fontSize:30,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w600,
                        fontFamily: "Roboto"),
                  )
                ]
            ),
              //reportList
              Expanded(
                child:
              generateReportList(20)
      )
        ]
        )
    );
  }

  ListView generateReportList(int numReports) {
    List<Widget> reports = <Widget>[];
    for(var i = 0; i < numReports; i++)
    {
      reports.add(TextButton(key:null, onPressed:buttonPressed,
          child:
          Text(
            "Text Button ${i + 1}",
            style: const TextStyle(fontSize:20.0,
                color: Color(0xFF000000),
                fontWeight: FontWeight.w400,
                fontFamily: "Roboto"),
          )
      ));

      reports.add(const Divider(color: Color(0xFF5e5e5e)));
    }

      return ListView(
          children: reports
      );
  }

  void buttonPressed(){}
}