import 'package:flutter/material.dart';
import 'package:moveasy/routes/welcome.dart';
import 'package:moveasy/utils/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int Page_index = 0;

  void UpdateState(int index)
  {
    setState(() {
      Page_index = index;
    });

    if (Page_index == 0) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Welcome()), (Route<dynamic> route) => false);
    }
    else if (index == 1) {

    }
    else if (index == 2) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moveasy'),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(onPressed:() {}, icon: Icon(Icons.search, color: AppColors.textSecondaryColor,))
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.secondaryColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
        ),
        child: ListView(
          children: [
            Center(
              child: Text("Trending Movies", style: TextStyle(color: AppColors.textColor, fontSize: 40),),
            ),


            SizedBox(height: 100,),

            Center(
              child: Text("New Releases", style: TextStyle(color: AppColors.textColor, fontSize: 40)),
            ),

            SizedBox(height: 100,),
            Center(
              child: Text("Upcoming", style: TextStyle(color: AppColors.textColor, fontSize: 40)),
            ),

            SizedBox(height: 100,),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem> [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home",),
        BottomNavigationBarItem(icon: Icon(Icons.movie_creation_outlined), label: "User Library"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
      ],
        currentIndex: Page_index,
        onTap: (UpdateState),
        backgroundColor: AppColors.secondaryColor,
        selectedItemColor: AppColors.textSecondaryColor,
      )
    );
  }
}
