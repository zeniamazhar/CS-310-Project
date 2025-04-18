import 'package:flutter/material.dart';
import 'package:moveasy/utils/AppColors.dart';
import 'package:moveasy/utils/user_data.dart';
import 'package:email_validator/email_validator.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String username = '';
  String email = '';
  String pass = '';
  String confirmPass = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SignUp(), // Replace with Login() if you have the widget
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: SizedBox(
          height: 40,
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
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text("Sign Up",
                      style: TextStyle(fontSize: 50, color: AppColors.titleColor),
                      textAlign: TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a User? Login ",
                          style: TextStyle(
                              fontSize: 18, color: AppColors.textColor)),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                        child: Text("here.",
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColors.textColor,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2)),
                      )
                    ],
                  ),
                  SizedBox(height: 20),

                  // Name
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(fontSize: 16, color: AppColors.secondaryTextColor),
                      prefixIcon: Icon(Icons.person, color: AppColors.secondaryColor),
                      filled: true,
                      fillColor: AppColors.lightBackgroundColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: AppColors.borderColor)),
                    ),
                    validator: (val) =>
                    val == null || val.isEmpty ? 'Please enter your name' : null,
                    onChanged: (val) => setState(() => name = val),
                  ),
                  SizedBox(height: 15),

                  // Username
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(fontSize: 16, color: AppColors.secondaryTextColor),
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.secondaryColor),
                      filled: true,
                      fillColor: AppColors.lightBackgroundColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: AppColors.borderColor)),
                    ),
                    validator: (val) =>
                    val == null || val.isEmpty ? 'Please enter a username' : null,
                    onChanged: (val) => setState(() => username = val),
                  ),
                  SizedBox(height: 15),

                  // Email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 16, color: AppColors.secondaryTextColor),
                      prefixIcon: Icon(Icons.email, color: AppColors.secondaryColor),
                      filled: true,
                      fillColor: AppColors.lightBackgroundColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: AppColors.borderColor)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onChanged: (val) => setState(() => email = val),
                  ),
                  SizedBox(height: 15),

                  // Password
                  TextFormField(
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 16, color: AppColors.secondaryTextColor),
                      prefixIcon: Icon(Icons.lock, color: AppColors.secondaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility
                        , color: AppColors.secondaryColor,),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: AppColors.lightBackgroundColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: AppColors.borderColor)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    onChanged: (val) => setState(() => pass = val),
                  ),
                  SizedBox(height: 15),

                  // Confirm Password
                  TextFormField(
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(fontSize: 16, color: AppColors.secondaryTextColor),
                      prefixIcon: Icon(Icons.lock_outline, color: AppColors.secondaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                            color: AppColors.secondaryColor),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: AppColors.lightBackgroundColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: AppColors.borderColor)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != pass) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onChanged: (val) => setState(() => confirmPass = val),
                  ),
                  SizedBox(height: 20),

                  // Sign up button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        bool success = UserData.registerUser(
                          email: email,
                          password: pass,
                          name: name,
                          username: username,
                          bio: "",
                        );
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Registration successful!')),
                          );
                          Future.delayed(Duration(milliseconds: 800), () {
                            Navigator.pushReplacementNamed(context, '/login');
                          });
                        }
                        else {
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
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Invalid Form'),
                            content: Text('Please fill in all fields correctly.'),
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
                      backgroundColor: WidgetStatePropertyAll(AppColors.darkButtonColor),
                      padding: WidgetStateProperty.all(
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                      minimumSize: WidgetStateProperty.all(Size(double.infinity, 50)),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(
                          color: AppColors.darkButtonTextColor, fontSize: 30),
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
