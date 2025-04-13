import 'package:flutter/material.dart';
import 'package:moveasy/utils/colors.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int pageIndex;
  final Function(int) onTap;

  const AppScaffold({
    required this.title,
    required this.body,
    required this.pageIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {}, // search functionality will go here
          ),
        ],
        centerTitle: true,
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: onTap,
        backgroundColor: AppColors.secondaryColor,
        selectedItemColor: AppColors.textSecondaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation_outlined), label: 'User Library'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
