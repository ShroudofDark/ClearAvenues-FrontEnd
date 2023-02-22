
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Register'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   const Text(
                'Create an account',
                style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
            ),
            ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                  decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  labelText: 'Name',
                  border: OutlineInputBorder(),
            ),
            ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                  decoration: const InputDecoration(
                  hintText: 'Enter your email address',
                  labelText: 'Email',
                  border: OutlineInputBorder(),
            ),
            ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  border: OutlineInputBorder(),
            ),
            ),

                  const SizedBox(height: 16.0),
                  TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                  hintText: 'Confirm your password',
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
            ),
            ),

                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Register'),
                   ),
            ],
            ),
        ),
    );
  }
}

