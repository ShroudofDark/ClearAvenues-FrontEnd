import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

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
          backgroundColor: Colors.green,
          title: const Text('Setting'),
        ),
        body: ListView(
          children: <Widget>[
            //general section
            const ExpansionTile(title: Text("General"), children: <Widget>[
              ListTile(
                title: Text("App Version"),
                subtitle: Text("1.0.0"),
              ),
              ListTile(
                title: Text("About"),
                subtitle: Text("Description goes here"),
              ),
            ]),
            ExpansionTile(
              title: const Text("Notifications"),
              children: [
                Center(
                    child: ElevatedButton(
                  child: Text(_notificationValue ? "OFF" : "ON"),
                  onPressed: () {
                    setNotificationValue(!_notificationValue);
                  },
                ))
              ],
            ),
            ExpansionTile(title: Text("Account"), children: <Widget>[
              ListTile(
                  title: const Text("Login"),
                  onTap: () {
                    ElevatedButton(
                        child: const Text("Login"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        });
                  })
            ]),
            const ExpansionTile(title: Text("Helo"), children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("This section provides information and resources"
                    "to help you use the app."),
              )
            ]),
            const ExpansionTile(title: Text("Report Bug"), children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Report bug is a feature in the application"
                    "that allows the users to report any issue."),
              )
            ])
          ],
        ));
  }
}
