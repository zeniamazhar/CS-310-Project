import 'package:flutter/material.dart';
import 'package:moveasy/utils/AppColors.dart';
import 'package:moveasy/utils/app_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  void updateState(int index) {
    setState(() {
      pageIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/movieList');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageIndex: pageIndex,
      onTap: updateState,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.only(top: kToolbarHeight + 16),
          children: [
            Center(
              child: Text(
                "Trending Movies",
                style: TextStyle(color: AppColors.titleColor, fontSize: 40),
              ),
            ),
            const SizedBox(height: 20),
            Image.network(
              'https://upload.wikimedia.org/wikipedia/en/thumb/6/66/A_Minecraft_Movie_poster.jpg/250px-A_Minecraft_Movie_poster.jpg',
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "New Releases",
                style: TextStyle(color: AppColors.titleColor, fontSize: 40),
              ),
            ),
            const SizedBox(height: 20),
            Image.network(
              'https://upload.wikimedia.org/wikipedia/en/thumb/a/a4/Captain_America_Brave_New_World_poster.jpg/250px-Captain_America_Brave_New_World_poster.jpg',
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Upcoming",
                style: TextStyle(color: AppColors.titleColor, fontSize: 40),
              ),
            ),
            const SizedBox(height: 20),
            Image.network(
              'https://upload.wikimedia.org/wikipedia/en/thumb/b/b9/Black_Bag_film_poster.jpg/250px-Black_Bag_film_poster.jpg',
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
