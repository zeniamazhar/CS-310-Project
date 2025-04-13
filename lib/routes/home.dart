import 'package:flutter/material.dart';
import 'package:moveasy/utils/colors.dart';

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

    // Navigate to different pages based on the tapped index
    if (pageIndex == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (pageIndex == 1) {
      Navigator.pushNamed(context, '/movieList'); // The "User Library" screen
    } else if (pageIndex == 2) {
      // Show an AlertDialog that the Profile page is not implemented yet
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Coming Soon!'),
          content: Text('The profile page is not implemented yet.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('OK'),
            )
          ],
        ),
      );
    }
  }


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
        // The gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // ListView is scrollable by default
        child: ListView(
          // Give top padding so content doesn't overlap the transparent app bar
          padding: EdgeInsets.only(top: kToolbarHeight + 20),
          children: [
            Center(
              child: Text(
                "Trending Movies",
                style: TextStyle(color: AppColors.textColor, fontSize: 40),
              ),
            ),

            // Example network image
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/en/thumb/6/66/A_Minecraft_Movie_poster.jpg/250px-A_Minecraft_Movie_poster.jpg',
              ),
            ),

            Center(
              child: Text(
                "New Releases",
                style: TextStyle(color: AppColors.textColor, fontSize: 40),
              ),
            ),

            // Example network image
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/en/thumb/a/a4/Captain_America_Brave_New_World_poster.jpg/250px-Captain_America_Brave_New_World_poster.jpg',
              ),
            ),

            SizedBox(height: 80),
            Center(
              child: Text(
                "Upcoming",
                style: TextStyle(color: AppColors.textColor, fontSize: 40),
              ),
            ),
            // Example network image
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/en/thumb/b/b9/Black_Bag_film_poster.jpg/250px-Black_Bag_film_poster.jpg',
              ),
            ),

            SizedBox(height: 80),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation_outlined), label: "User Library"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: pageIndex,
        onTap: updateState,
        backgroundColor: AppColors.secondaryColor,
        selectedItemColor: AppColors.textSecondaryColor,
      ),
    );
  }
}