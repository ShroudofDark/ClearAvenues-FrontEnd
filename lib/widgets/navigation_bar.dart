import 'package:clear_avenues/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/* Navigation bar is toolbar that expands from the left screen
 * and provides navigation options for the user in order to access
 * different screens.
 */

class NavBar extends ConsumerWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userProvider);
    final userName = ref.watch(userProvider).name;

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

    return SizedBox(
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
                  currentAccountPicture: Center(
                      child: CircleAvatar(
                        radius: 70,
                        child: Text(user.name ?? ""),
                      )
                  ),
                  accountName: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Flexible (
                        child: Text(
                          userName ?? "Signed Out",
                            style: const TextStyle(
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
                  accountEmail: Text(user.email ?? "")

                ),
              ),
              //Navigation Points - Simple Style

              createListTile('/notification','Notifications', Icons.notifications),
              createListTile('/view_history','History', Icons.history),
              createListTile('/view_organization','Organization', Icons.business),
              createListTile('/analysis','Analysis', Icons.analytics),

              separator(),

              //Needs to change onTap to be based on log on status
              ListTile(
                onTap: () {
                  if(userName != null) {
                    context.push('/accountInfo');
                  }
                  else {
                    context.push('/login');
                  }
                },
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text('Account',
                  style: navStyle,
                ),
                contentPadding: navigationListPadding,
              ),
              createListTile('/setting','Settings', Icons.settings),

              separator(),

              createListTile('/help','Help', Icons.question_mark_rounded),
              createListTile('/about','About', Icons.info_outline_rounded),

              //Different from others due to just launching a form instead
              ListTile(
                //Altered from Keshaun's Dev Screen
                onTap: () => _launchURL(),
                leading: const Icon(
                  Icons.bug_report,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text('Bug Report',
                  style: navStyle,
                ),
                contentPadding: navigationListPadding,
              ),

              createListTile('/demo_button','Demo Buttons', Icons.developer_mode),

            ],
          )
        )
      ),
    );
  }
}

_launchURL() async {
  const url = 'https://docs.google.com/forms/d/e/1FAIpQLSdepgyxcRTXgfiWBmG4imazlIl2ni3VJcjhPQ_JP_81ws96Tw/viewform?usp=sf_link';
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
