import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/* Navigation bar is toolbar that expands from the left screen
 * and provides navigation options for the user in order to access
 * different screens.
 */

class NavBar extends StatelessWidget {
  NavBar({super.key});

  @override
  Widget build(BuildContext context) {

    //Variable List
    double drawerWidth = MediaQuery.of(context).size.width * 0.9;
    EdgeInsetsGeometry navigationListPadding =  const EdgeInsets.symmetric(horizontal: 20,vertical: 5);
    TextStyle navStyle = const TextStyle(fontSize: 20, color: Colors.white);

    //Tiles For Navigation
    Widget createListTile(String navPath, String navName, IconData iconType) {
      //https://api.flutter.dev/flutter/material/ListTile-class.html
      return ListTile(
        //Altered from Keshaun's Dev Screen
        onTap: () => context.push(navPath),

        leading: Icon(
          iconType,
          color: Colors.white,
          size: 30,
        ),
        title: Text(navName,
          style: navStyle,
        ),
        contentPadding: navigationListPadding,
      );
    }

    //Separtor For Navigation
    Widget separator() {
      return const Divider(color: Colors.white, thickness: 4, height: 30, indent: 10, endIndent: 50);
    }

    return Container(
      width: drawerWidth,
      child: Drawer(
        //Determines what is within the drawer widget
        child: Container(
          //Attributes of Drawer Here
          color: Colors.black87,

          //Objects inside of Drawer here - List used b/c ability to scroll
          child: ListView(
            //List View Attributes here
            padding: EdgeInsets.zero,

            children: [

              SizedBox(
                height: 250,
                //https://api.flutter.dev/flutter/material/UserAccountsDrawerHeader-class.html
                /**
                 * TODO May need to adjust this into custom DrawerHeader if need more flexibility
                 * Determine later
                 */
                child: UserAccountsDrawerHeader(
                  /**
                   * https://stackoverflow.com/questions/70003147/how-to-center-circleavatar-on-enddrawer
                   * Learned how to center the avatar figure by user Maikzen
                   */
                  currentAccountPictureSize: Size(drawerWidth *.97, 135),
                  currentAccountPicture: const Center(
                      child: CircleAvatar(
                        radius: 70,
                        child: Text('DE'), //TODO image or autogenerated initials?
                      )
                  ),
                  accountName: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Flexible (
                        child: Text(
                          //TODO Load logged in user name here
                          "Guest",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          textAlign: TextAlign.center,
                          softWrap: false,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  // Required for UserAccountsDrawerHeader, but can set null
                  accountEmail: null,

                ),
              ),
              //Navigation Points - Simple Style

              createListTile('/notification','Notifications', Icons.notifications),
              createListTile('/view_history','History', Icons.history),
              createListTile('/view_organization','Organization', Icons.business),
              createListTile('/analysis','Analysis', Icons.analytics),

              separator(),

              createListTile('/login','Account', Icons.person), //TODO different screen depending on login status
              createListTile('/setting','Settings', Icons.settings),

              separator(),

              createListTile('/help','Help', Icons.question_mark_rounded),
              createListTile('/about','About', Icons.info_outline_rounded),
              createListTile('/bug_report','Bug Report', Icons.bug_report),

            ],
          )
        )
      ),
    );

  }
}

