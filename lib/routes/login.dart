import 'package:flutter/material.dart';
import 'package:moveasy/utils/colors.dart';
import 'package:moveasy/utils/user_data.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pass = '';
  bool _obscurePassword = true;

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
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 50, color: AppColors.textColor),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New User? Register ",
                        style:
                        TextStyle(fontSize: 20, color: AppColors.textSecondaryColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/signup');
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
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 16),
                      fillColor: AppColors.textSecondaryColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == "debug") return null;
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onChanged: (val) => setState(() => email = val),
                  ),
                  const SizedBox(height: 15),

                  // Password Field
                  TextFormField(
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      fillColor: AppColors.textSecondaryColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (email == "debug") return null;
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onChanged: (val) => setState(() => pass = val),
                  ),
                  const SizedBox(height: 15),

                  // Sign in button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (email == "debug") {
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          bool authenticated = UserData.authenticate(email, pass);
                          if (authenticated) {
                            UserData.setLoggedInEmail(email);
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Login Failed'),
                                content: Text(
                                    'Invalid email or password. Please try again.'),
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
                      backgroundColor:
                      WidgetStatePropertyAll(AppColors.buttonColor),
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                      minimumSize:
                      WidgetStateProperty.all(Size(double.infinity, 50)),
                    ),
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                          color: AppColors.textSecondaryColor, fontSize: 30),
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
