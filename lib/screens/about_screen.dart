import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Clear Avenues',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Clear Avenues is a mobile application designed to provide users with up-to-date information about road conditions, traffic, and other relevant data.',
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Intended Purpose',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'The application is intended to help users plan their routes and avoid traffic congestion, as well as report any road conditions or incidents that may affect others.',
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Version',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '1.0.0',
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Development Team',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Backend Developer/Frontend Developer: Keshaun Banks'
                      '\nBackend Developer/Documentation Specialist: Cody Littman'
                      '\nTeam Leader/Webmaster: Jacob McFadden'
                      '\nFrontend developer/Web Developer: Afnan Saed'
                      '\nBackend Developer/Database Manager: Matthew Wilson',
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Contact Information',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Email: support@clearavenues.com\nPhone: 555-1234',
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Legal Information',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Terms of Use:\nBy using the Clear Avenues application, '
                      'you agree to abide by our terms of use. '
                      'These include using the app for lawful purposes '
                      'and not violating the rights of others.'
                      '\n\nPrivacy Policy:\nBy using the Clear Avenues '
                      'application, you agree to abide by our terms of use. '
                      'These include using the app for lawful purposes'
                      ' and not violating the rights of others.',
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/help');
                  },
                  child: const Text('Help'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




