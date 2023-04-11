import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: ListView(

        children: <Widget>[
          const Padding(
              padding : EdgeInsets.all(16.0),
              child: Text(
                'Welcome to Clear Avenues!',
              style: TextStyle(
                 fontSize: 16.0,
                 ),
                ),
          ),
          const ExpansionTile(
            title: Text('Navigation'),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                    'To navigate through the app, use the bottom navigation bar. '
                        'The icons on the bar represent the different screens available in the app. '
                        'Tap on an icon to navigate to the corresponding screen.'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('How to Report a Road Condition'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                        'To report a road condition, follow these steps:\n\n'
                            '1. Tap on the "Report" icon on the bottom navigation bar.\n\n'
                            '2. Tap on the "Add Report" button.\n\n'
                            '3. Enter the details of the road condition, such as the location and type of issue.\n\n'
                            '4. Optionally, add a photo of the road condition.\n\n'
                            '5. Tap on the "Submit" button to submit the report.'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {

                          context.push('/report');

                      },
                      child: const Text('Go to Report Screen'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Troubleshoot common issues'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                        'If you encounter any issues or errors while using the app, '
                            'try the following solutions:\n\n'
                            '1. Check your internet connection. The app requires an internet connection to work properly.\n\n'
                            '2. Make sure you are using the latest version of the app. '
                            'You can check for updates in the app store.\n\n'
                            '3. If the issue persists, contact our support team at support@clearavenues.com.'),
                    SizedBox(height: 10),
                    Text(
                      'If you encounter any technical issues, please include the following information '
                          'in your support request:\n\n'
                          '- The version of the app you are using\n\n'
                          '- The device and operating system you are using\n\n'
                          '- A detailed description of the issue or error',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

