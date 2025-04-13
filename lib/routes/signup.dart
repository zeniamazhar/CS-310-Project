import 'package:flutter/material.dart';
import 'package:moveasy/utils/colors.dart';
import 'package:moveasy/utils/user_data.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey, // <--- Wrap with Form
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 50, color: AppColors.textColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New User? Register ",
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          "here.",
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
                  SizedBox(height: 20),

                  // Email field
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: SizedBox(
                        width: 100,
                        child: Row(
                          children: [Icon(Icons.email), Text('Email')],
                        ),
                      ),
                      fillColor: AppColors.textSecondaryColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      // Basic validation check - you can add a regex if you want
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  SizedBox(height: 15),

                  // Password field
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true, // hide password
                    decoration: InputDecoration(
                      label: SizedBox(
                        width: 106,
                        child: Row(
                          children: [Icon(Icons.key), Text('Password')],
                        ),
                      ),
                      fillColor: AppColors.textSecondaryColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      // For demonstration, require at least 4 characters
                      if (value.length < 4) {
                        return 'Password must be at least 4 characters long';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        pass = val;
                      });
                    },
                  ),
                  SizedBox(height: 15),

                  // Sign up button
                  ElevatedButton(
                    onPressed: () {
                      // Validate fields
                      if (_formKey.currentState!.validate()) {
                        // Attempt to register user
                        bool success = UserData.registerUser(email, pass);
                        if (success) {
                          // Registered successfully
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Registration successful!'),
                            ),
                          );
                          // Go to Home or login
                          Navigator.pushNamed(context, '/login');
                        } else {
                          // Show alert dialog if email is taken
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Registration Failed'),
                              content: Text('This email is already registered.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        // Show alert dialog that form is invalid
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Invalid Form'),
                            content: Text('Please fill all fields correctly.'),
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
                      "Sign up",
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
