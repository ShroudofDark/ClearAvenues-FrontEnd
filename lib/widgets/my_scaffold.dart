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
        //Edits where you can start a drag motion to open the side bar
        //Currently entire size of screen due to finicky behavior where it closes app
        drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        title: const Text("Clear Avenues"),
      ),

      body: body,
    );
  }
}

