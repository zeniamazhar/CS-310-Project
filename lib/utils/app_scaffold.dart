import 'package:flutter/material.dart';
import 'package:moveasy/utils/AppColors.dart';
import 'package:moveasy/routes/searchPage.dart';


class AppScaffold extends StatelessWidget {
  final Widget body;
  final int pageIndex;
  final Function(int) onTap;

  const AppScaffold({
    required this.body,
    required this.pageIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,

        // 🧹 Removed the back button:
        // leading: IconButton(...)

        title: SizedBox(
          height: 40,
          child: Image.asset('assets/images/logo_small.png'),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),

        ],
      ),
      extendBodyBehindAppBar: true,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: onTap,
        backgroundColor: AppColors.secondaryTextColor,
        selectedItemColor: AppColors.textColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation_outlined), label: 'User Library'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
