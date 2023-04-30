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

    //Variable List
    double drawerWidth = MediaQuery.of(context).size.width * 0.9;
    EdgeInsetsGeometry navigationListPadding =  const EdgeInsets.symmetric(horizontal: 20,vertical: 5);
    TextStyle navStyle = const TextStyle(fontSize: 20, color: Colors.white);

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
                  currentAccountPicture: const Center(
                      child: CircleAvatar(
                        radius: 70,
                        child: Icon(Icons.person, size: 100),
                      )
                  ),
                  accountName: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Flexible (
                        child: Text(
                          user.name ?? "Signed Out",
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
                  accountEmail: null
                ),
              ),
              ListTile(
                onTap: () => context.push('/notification'),

                leading: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text("Notifications",
                  style: navStyle,
                ),
                contentPadding: navigationListPadding,
              ),
              ListTile(
                onTap: () => context.push('/view_history'),

                leading: const Icon(
                  Icons.history,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text("History",
                  style: navStyle,
                ),
                contentPadding: navigationListPadding,
              ),
              ListTile(
                onTap: () => context.push('/view_organization'),

                leading: const Icon(
                  Icons.business,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text("Organization",
                  style: navStyle,
                ),
                contentPadding: navigationListPadding,
              ),
              ListTile(
                onTap: () => context.push('/analysis'),

                leading: const Icon(
                  Icons.analytics,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text("Analysis",
                  style: navStyle,
                ),
                contentPadding: navigationListPadding,
              ),

              const Divider(color: Colors.white, thickness: 4, height: 30, indent: 10, endIndent: 50),

              //Needs to change onTap to be based on log on status
              ListTile(
                onTap: () {
                  if(user.name != null) {
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
              ListTile(
                onTap: () => context.push('/setting'),

                leading: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text("Settings",
                  style: navStyle,
                ),
                contentPadding: navigationListPadding,
              ),

              const Divider(color: Colors.white, thickness: 4, height: 30, indent: 10, endIndent: 50),

              ListTile(
                onTap: () => context.push('/help'),

                leading: const Icon(
                  Icons.question_mark_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text("Help",
                  style: navStyle,
                ),
                contentPadding: navigationListPadding,
              ),

              ListTile(
                onTap: () => context.push('/about'),

                leading: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text("About",
                  style: navStyle,
                ),
                contentPadding: navigationListPadding,
              ),

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
              ListTile(
                onTap: () => context.push('/demo_button'),

                leading: const Icon(
                  Icons.developer_mode,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text("Demo Buttons",
                  style: navStyle,
                ),
                contentPadding: navigationListPadding,
              ),
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
