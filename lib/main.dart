import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';  // Import Firebase Core
import 'package:moveasy/routes/login.dart';
import 'package:moveasy/routes/movie_list.dart';
import 'package:moveasy/routes/signup.dart';
import 'package:moveasy/routes/welcome.dart';
import 'package:moveasy/routes/home.dart';
import 'package:moveasy/routes/profile.dart';
import 'package:moveasy/routes/searchPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure Flutter bindings are initialized
  await Firebase.initializeApp();  // Initialize Firebase before running the app
  runApp(MyApp());  // Run the app after Firebase initialization is complete
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat', // same as the family name in pubspec
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => Welcome(),
        '/signup': (context) => SignUp(),
        '/login': (context) => Login(),
        '/home': (context) => HomePage(),
        '/movieList': (context) => MovieListScreen(),
        '/profile': (context) => ProfilePage(),
        '/searchPage': (context) => SearchPage(),
      },
    );
  }
}