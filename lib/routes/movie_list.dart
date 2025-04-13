import 'package:flutter/material.dart';
import 'package:moveasy/utils/colors.dart';
import 'package:moveasy/utils/movie.dart';
import 'watch_later_page.dart';
import 'favorites_page.dart';
import 'watch_list_page.dart';
import 'movie_detail_page.dart';
import 'package:moveasy/utils/app_scaffold.dart';

class MovieListScreen extends StatefulWidget {
  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  int pageIndex = 1;

  void onNavigationTap(int index) {
    setState(() {
      pageIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {

    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  final List<Movie> watchLater = [
    Movie(title: 'Inception', year: '2010'),
    Movie(title: 'Avatar', year: '2009'),
    Movie(title: 'The Revenant', year: '2015'),
    Movie(title: 'The Shawshank Redemption', year: '1994'),

  ];

  final List<Movie> favorites = [
    Movie(title: 'Interstellar', year: '2014'),
    Movie(title: 'The Dark Knight', year: '2008'),
  ];

  final List<Movie> watchList = [
    Movie(title: 'Tenet', year: '2020'),
    Movie(title: 'Dune', year: '2021'),
  ];

  void navigateToListPage(BuildContext context, String title, List<Movie> movieList) {
    if (title == 'Watch Later') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WatchLaterPage(movies: movieList)),
      );
    } else if (title == 'Favorites') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FavoritesPage(movies: movieList)),
      );
    } else if (title == 'Watch List') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WatchListPage(movies: movieList)),
      );
    }
  }
  void navigateToDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailPage(movie: movie),
      ),
    );
  }

  Widget buildMovieCarousel(String title, List<Movie> movieList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            navigateToListPage(context, title, movieList);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonColor,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              final movie = movieList[index];
              return GestureDetector(
                onTap: () => navigateToDetail(movie),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: 160,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Year: ${movie.year}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.buttonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'User Library',
      pageIndex: pageIndex,
      onTap: onNavigationTap,
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildMovieCarousel("Watch Later", watchLater),
              buildMovieCarousel("Favorites", favorites),
              buildMovieCarousel("Watch List", watchList),
            ],
          ),
        ),
      ),
    );
  }

}