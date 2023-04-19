import 'package:clear_avenues/features/reporting/provider.dart';
import 'package:flutter/material.dart';
import 'package:clear_avenues/widgets/my_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewHistory extends ConsumerStatefulWidget {
  const ViewHistory({Key? key}) : super(key: key);

  @override
  ConsumerState<ViewHistory> createState() => _ViewHistoryState();
}

class _ViewHistoryState extends ConsumerState<ViewHistory> {

  @override
  Widget build(BuildContext context) {
    final reportList = ref.watch(userReportProvider);
    return MyScaffold(
        body: reportList.when(
            data: (reports) {
              return ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final comment = reports[index].reportComment;
                  final reportType = reports[index].reportType;
                  return ListTile(
                    title: Text(reportType),
                    subtitle: Text(comment),
                    trailing: const Icon(Icons.more_vert),
                    isThreeLine: true,
                  );
                },
              );
            },
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const CircularProgressIndicator()));
  }

  ListView generateReportList(int numReports) {
    List<Widget> reports = <Widget>[];
    for (var i = 0; i < numReports; i++) {
      reports.add(TextButton(
          key: null,
          onPressed: buttonPressed,
          child: Text(
            "Text Button ${i + 1}",
            style: const TextStyle(
                fontSize: 20.0,
                color: Color(0xFF000000),
                fontWeight: FontWeight.w400,
                fontFamily: "Roboto"),
          )));

      reports.add(const Divider(color: Color(0xFF5e5e5e)));
    }

    return ListView(children: reports);
  }

  void buttonPressed() {}
}
