import 'package:flutter/material.dart';
import 'package:moveasy/utils/AppColors.dart';
import 'package:moveasy/utils/movie.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kToolbarHeight + 16),
                Text(
                  movie.title,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "Release Year: ${movie.year}",
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
                SizedBox(height: 30),
                Text(
                  "More details coming soon...",
                  style: TextStyle(fontSize: 18, color: Colors.white60),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
