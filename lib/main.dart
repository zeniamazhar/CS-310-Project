import 'package:flutter/material.dart';
import 'package:moveasy/routes/login.dart';
import 'package:moveasy/routes/movie_list.dart';
import 'package:moveasy/routes/signup.dart';
import 'package:moveasy/routes/welcome.dart';
import 'package:moveasy/routes/home.dart';
import 'package:moveasy/routes/profile.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'Montserrat', // same as the family name in pubspec
    ),
    initialRoute: '/welcome',
    routes: {
      '/welcome': (context) => Welcome(),
      '/signup' : (context) => SignUp(),
      '/login': (context) => Login(),
      '/home': (context) => HomePage(),
      // We'll add a new route for the Card/List screen below
      '/movieList': (context) => MovieListScreen(),
      '/profile': (context) => ProfilePage(),

    },
  ));
}