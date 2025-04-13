import 'package:flutter/material.dart';
import 'package:moveasy/utils/colors.dart';

class Movie {
  final String title;
  final String year;

  Movie({required this.title, required this.year});
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  // Sample data
  List<Movie> movies = [
    Movie(title: 'Inception', year: '2010'),
    Movie(title: 'Interstellar', year: '2014'),
    Movie(title: 'Tenet', year: '2020'),
  ];

  void removeMovie(int index) {
    setState(() {
      movies.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Library'),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.secondaryColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
        ),
        child: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Card(
              // card content
              child: ListTile(
                title: Text(movies[index].title,
                  style: TextStyle(color: AppColors.textColor, fontSize: 18),
                ),
                subtitle: Text('Year: ${movies[index].year}',
                  style: TextStyle(color: AppColors.buttonColor),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.redAccent,
                  onPressed: () => removeMovie(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
