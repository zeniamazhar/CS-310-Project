import 'package:flutter/material.dart';
import 'package:moveasy/utils/colors.dart';
import 'package:moveasy/utils/user_data.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String pass = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This makes the gradient visible behind the app bar
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        // Make the AppBar transparent if you want gradient behind it
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        // Center an image as title:
        title: SizedBox(
          height: 40, // Adjust as needed
          child: Image.asset('assets/images/logo_small.png'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 50, color: AppColors.textColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New User? Register ",
                        style: TextStyle(fontSize: 20, color: AppColors.textSecondaryColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          "here. ",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.textSecondaryColor,
                            decoration: TextDecoration.underline,
                            decorationThickness: 3,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',  // no row needed
                      labelStyle: TextStyle(fontSize: 16), // can adjust size if you like
                      fillColor: AppColors.textSecondaryColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // Validator with "debug" override
                    validator: (value) {
                      // If user typed "debug", skip email format checks
                      if (value == "debug") {
                        return null;
                      }
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  const SizedBox(height: 15),

                  // Password Field
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 16),
                      fillColor: AppColors.textSecondaryColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // Validator with "debug" override
                    validator: (value) {
                      // If the user typed "debug" in email, skip password checks
                      if (email == "debug") {
                        return null;
                      }
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => pass = val);
                    },
                  ),
                  const SizedBox(height: 15),

                  // Sign in button
                  ElevatedButton(
                    onPressed: () {
                      // First, run form validation (with debug bypass in validators)
                      if (_formKey.currentState!.validate()) {
                        // If the user typed "debug" as email, skip all checks
                        if (email == "debug") {
                          Navigator.pushNamed(context, '/home');
                        } else {
                          // Otherwise, do the normal authentication
                          bool authenticated = UserData.authenticate(email, pass);
                          if (authenticated) {
                            Navigator.pushNamed(context, '/home');
                          } else {
                            // Invalid user credentials
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Login Failed'),
                                content: Text('Invalid email or password. Please try again.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      } else {
                        // The form was invalid for reasons other than "debug"
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Invalid Form'),
                            content: Text('Please fill in all fields properly.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(AppColors.buttonColor),
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                      minimumSize: WidgetStateProperty.all(Size(double.infinity, 50)),
                    ),
                    child: Text(
                      "Sign in",
                      style: TextStyle(color: AppColors.textSecondaryColor, fontSize: 30),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}