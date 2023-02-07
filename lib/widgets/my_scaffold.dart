import 'package:flutter/material.dart';

//test import
import 'package:clear_avenues/widgets/navigation_bar.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({Key? key, required this.body}) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text("Clear Avenues"),
      ),

      body: body,
    );
  }
}

