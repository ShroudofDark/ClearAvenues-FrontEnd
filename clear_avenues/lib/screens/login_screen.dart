import 'package:flutter/material.dart';
import 'package:clear_avenues/widgets/login_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,

      // Organize every widget on this screen into a column
      // This allows us to display everything vertically
      child: Column(
        // This column has multiple children...
        children: <Widget>[
          // Clear Avenues Title Text wrapped in a container to add padding
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: const Text(
              'Clear Avenues',
              style: TextStyle(fontSize: 30),
            ),
          ),
          // Same as above, but for Sign In
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Sign In',
              style: TextStyle(fontSize: 20),
            ),
          ),
          // Then we have 2 login form fields (our own custom widget in widgets/ folder
          const LoginFormField(
              errorText: "Please Enter Your Username/Email",
              label: "Username/Email"),
          const LoginFormField(
              errorText: "Please enter a password", label: "Password"),

          // Lastly, we have our 2 buttons
          ElevatedButton(
              onPressed: () => _onLoginPressed(), child: const Text('Login')),

          ElevatedButton(
              onPressed: () => _onRegisterPressed(),
              child: const Text('Register')),
        ],
      ),
    );
  }

  // This runs when login button is pressed
  void _onLoginPressed() {
    // Validates that the current form is valid
    if (_formKey.currentState!.validate()) {
      // Displays a message on bottom of screen that we're logging in
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Logging in")));
    }
  }

  void _onRegisterPressed() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
              title: Text(
                  "You should be on the register screen when this is pressed"));
        });
  }
}
