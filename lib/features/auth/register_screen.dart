import 'package:clear_avenues/features/auth/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//Used to fetch input data
TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

List<String> accountType = ["standard", "municipality", "institute"];
String? chosenAccount;

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  //Used for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    chosenAccount = accountType[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A Name is Required.';
                      }
                      return null;
                    }),
                const SizedBox(height: 16.0),
                TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email address',
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'An Email Address is Required';
                      }
                      //Weak level valid email check
                      if (!emailController.text.contains('@')) {
                        return 'Enter a Valid Email Address';
                      }
                      return null;
                    }),
                const SizedBox(height: 16.0),
                TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A Password is Required';
                      }
                      //Weak password strength check
                      if (passwordController.text.length < 8) {
                        return 'Minimum of 8 Characters Required';
                      }
                      return null;
                    }),
                const SizedBox(height: 16.0),
                TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Confirm your password',
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Above Password';
                      }
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        return 'Passwords Do Not Match';
                      }
                      return null;
                    }),
                const SizedBox(height: 16.0),
                Column(
                  children: [
                    const Text(
                      "Account Type",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        color: Colors.green,
                        height: 8.0,
                      ),
                    ),
                    RadioListTile(
                        title: const Text("Citizen"),
                        value: accountType[0],
                        groupValue: chosenAccount,
                        onChanged: (String? value) {
                          setState(() {
                            chosenAccount = value;
                          });
                        }),
                    RadioListTile(
                        title: const Text("Municipality"),
                        value: accountType[1],
                        groupValue: chosenAccount,
                        onChanged: (String? value) {
                          setState(() {
                            chosenAccount = value;
                          });
                        }),
                    RadioListTile(
                        title: const Text("Institute"),
                        value: accountType[2],
                        groupValue: chosenAccount,
                        onChanged: (String? value) {
                          setState(() {
                            chosenAccount = value;
                          });
                        }),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _registerUser(),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registerUser() async {
    //If the validation is successful, register user
    if (_formKey.currentState!.validate()) {
      bool success = await ref.read(authServiceProvider).registerUser(
          emailController.text,
          nameController.text,
          passwordController.text,
          chosenAccount!);
      if (context.mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration Complete")));
      }
      if (context.mounted) {
        emailController.clear();
        nameController.clear();
        passwordController.clear();
        context.pop();
      }
    }
  }
}
