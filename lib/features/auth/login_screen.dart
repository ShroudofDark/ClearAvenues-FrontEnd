import 'package:flutter/material.dart';
import 'package:clear_avenues/widgets/login_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/my_scaffold.dart';
import 'AuthProvider.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Form(
        key: _formKey,

        // Organize every widget on this screen into a column
        // This allows us to display everything vertically
        child: SingleChildScrollView(
          child: Column(
            // This column has multiple children...
            children: <Widget>[
              const SizedBox(height: 16.0),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/ClearAveLogo.png',
                  width: 300.0,
                  height: 300.0,
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
              // Then we have 2 login form fields (our own custom widget in widgets/ folder)
              LoginFormField(
                  textController: emailController,
                  errorText: "Please Enter Your Username/Email",
                  label: "Username/Email"),
              LoginFormField(
                  textController: passwordController,
                  errorText: "Please enter a password",
                  label: "Password"),

              // Lastly, we have our 2 buttons
              ElevatedButton(
                  onPressed: () => _onLoginPressed(),
                  child: const Text('Login')),

              ElevatedButton(
                  onPressed: () => _onRegisterPressed(),
                  child: const Text('Register')),
            ],
          ),
        ),
      ),
    );
  }

  // This runs when login button is pressed
  void _onLoginPressed() async {
    // Validates that the current form is valid
    if (_formKey.currentState!.validate()) {
      // Displays a message on bottom of screen that we're logging in
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Logging in")));

      // Add login logic here
      var success = await ref
          .read(authServiceProvider)
          .loginAuthentication(emailController.text, passwordController.text, ref);
      if (success == true && context.mounted) {
        emailController.clear();
        passwordController.clear();
        context.pop();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Unable to Login")));
      }
    }
  }

  void _onRegisterPressed() {
    context.push('/register');
  }
}
