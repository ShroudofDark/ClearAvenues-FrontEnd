import 'package:flutter/material.dart';
import 'login_screen.dart';



class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  bool _notificationValue = false;
  void setNotificationValue(bool value) {
    setState(() {
      _notificationValue = value;
      // _notificationValue = !_notificationValue;
    });
  }

  bool getNotificationValue() {
    return _notificationValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: const Text('Setting'),
        ),
        body: ListView(
            children:  <Widget> [
              //general section
              const ExpansionTile (
                  title: Text("General"),
                  children:<Widget>[
                    ListTile(
                      title: Text("App Version"),
                      subtitle: Text("1.0.0"),
                    ),
                    ListTile(
                      title: Text("About"),
                      subtitle: Text("Description goes here"),

                    ),
                  ]
              ),
              ExpansionTile(
                title: const Text("Notifications"),
                children: [
                  Center(
                      child: ElevatedButton(
                        child: Text(
                            _notificationValue ? "OFF" : "ON"
                        ),
                        onPressed: (){
                          setNotificationValue(!_notificationValue);
                        },

                      )
                  )

                ],

              ),
              ExpansionTile(
                  title: Text ("Account"),
                  children: <Widget>[
                    ListTile(
                        title: const Text("Login"),
                        onTap: (){

                          ElevatedButton(
                              child: const Text("Login"),

                              onPressed: () {

                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),

                                );
                              }
                          );

                        }
                    )
                  ]
              )
            ]
        )
    );
  }
}
