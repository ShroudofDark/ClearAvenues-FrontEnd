import 'package:flutter/material.dart';
//import '../auth/login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  bool _notificationsEnabled = true;
  double _soundLevel = 50;
  bool _alertsMuted = false;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildGeneralCategory(textStyle),
          _buildVoiceAndSoundCategory(textStyle),
        ],
      ),
    );
  }

  Widget _buildGeneralCategory(TextStyle textStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'General',
            style: textStyle,
          ),
        ),
        const Divider(height: 0),
        const ListTile(
          title: Text('App Version'),
          trailing: Text('1.0'),
        ),
        SwitchListTile(
          title: const Text('Notifications'),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildVoiceAndSoundCategory(TextStyle textStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Volume ',
            style: textStyle,
          ),
        ),
        const Divider(height: 0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Sound Level',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Slider(
          value: _soundLevel,
          min: 0,
          max: 100,
          onChanged: (value) {
            setState(() {
              _soundLevel = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Mute Alerts'),
          value: _alertsMuted,
          onChanged: (value) {
            setState(() {
              _alertsMuted = value;
            });
          },
        ),
      ],
    );
  }
}
