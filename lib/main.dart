import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ Add this for Riverpod

import 'package:moveasy/routes/login.dart';
import 'package:moveasy/routes/movie_list.dart';
import 'package:moveasy/routes/signup.dart';
import 'package:moveasy/routes/welcome.dart';
import 'package:moveasy/routes/home.dart';
import 'package:moveasy/routes/profile.dart';
import 'package:moveasy/routes/searchPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => Welcome(),
        '/signup': (context) => SignUp(),
        '/login': (context) => Login(),
        '/home': (context) => const HomePage(),
        '/movieList': (context) => MovieListScreen(),
        '/profile': (context) => ProfilePage(),
        '/searchPage': (context) => SearchPage(),
      },
    );
  }
}
