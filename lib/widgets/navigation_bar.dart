import 'package:flutter/material.dart';

/* Navigation bar is toolbar that expands from the left screen
 * and provides navigation options for the user in order to access
 * different screens.
 */

class NavBar extends StatelessWidget {
  NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    //Boolean to determine if drawer menu is open or not
    bool isCollapsed = true; //TODO change so its not always false

    return Container(
      //Boolean check to determine width. True = left side, false = right side.
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(
        //Determines what is within the drawer widget
        child: Container(
          color: Colors.green,
          //Create a child widget that is part of the container
          child: Column(
            children: [
              //Insert Children widgets of the Column
            ],
          )
        )
      ),
    );
  }
}