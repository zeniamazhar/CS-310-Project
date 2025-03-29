import 'package:flutter/material.dart';
import 'package:moveasy/routes/login.dart';
import 'package:moveasy/routes/signup.dart';
import 'package:moveasy/routes/welcome.dart';
import 'package:moveasy/routes/home.dart';

void main() {
  runApp(MaterialApp(
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => Welcome(),
        '/signup' : (context) => SignUp(),
        '/login': (context) => Login(),
        '/home': (context) => HomePage()
      }
  ));
}