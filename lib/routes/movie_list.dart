import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moveasy/utils/AppColors.dart';
import 'package:moveasy/utils/movie.dart';
import 'package:moveasy/utils/app_scaffold.dart';
import 'movie_detail_page.dart';
import 'package:moveasy/utils/movie.dart';


class MovieListScreen extends StatefulWidget {
  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  int pageIndex = 1;
  Map<String, bool> isEditingMap = {
    'watchLater': false,
    'favorites': false,
    'watchList': false,
  };

  void onNavigationTap(int index) {
    setState(() => pageIndex = index);

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  Future<List<Movie>> fetchMoviesFromList(String listName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = snapshot.data();
    if (data == null || data[listName] == null) return [];

    final List<dynamic> rawMovies = data[listName];
    return rawMovies
        .map((movie) => Movie(
      id: movie['id'],
      title: movie['title'] ?? '',
      releaseDate: movie['release_date']?.split('-')[0] ?? 'Unknown',
      posterPath: movie['poster_path'],
      voteAverage: movie['vote_average'],
      overview: movie['overview'],
    ))
        .toList();
  }

  Future<void> deleteMovieFromList(String listName, int movieId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await userRef.get();
    final data = snapshot.data();

    if (data == null || data[listName] == null) return;

    List<dynamic> movies = List.from(data[listName]);

    movies.removeWhere((movie) => movie['id'] == movieId);

    await userRef.update({listName: movies});

    setState(() {}); // Refresh UI after deletion
  }

  void navigateToDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
    );
  }

  Widget buildMovieCarousel(String title, String listName) {
    return FutureBuilder<List<Movie>>(
      future: fetchMoviesFromList(listName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final movies = snapshot.data ?? [];
        final isEditing = isEditingMap[listName] ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Center(
            child: Row(
              children: [
                SizedBox(width:50),
                Expanded(
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MovieListDetailScreen(
                              listName: listName,
                              title: title,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (isEditing) {
                        isEditingMap.updateAll((key, value) => false);
                      } else {
                        isEditingMap.updateAll((key, value) => key == listName);
                      }
                    });
                  },
                  child: Text(
                    isEditing ? "Done" : "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
            ),

            SizedBox(height: 10),
            if (isEditing)
              movies.isEmpty
                  ? Center(
                child: Column(
                    children:[
                      SizedBox(height:40),
                      Text("No movies added yet!",
                    style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(height:40),]
              )

              ): ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    color: Colors.grey[900],
                    margin:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: movie.posterPath != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w154${movie.posterPath}',
                          width: 50,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Icon(Icons.movie, size: 80),
                      title: Text(movie.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(movie.releaseDate,
                          style:
                          TextStyle(color: Colors.white70, fontSize: 14)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          await deleteMovieFromList(listName, movie.id);
                        },
                      ),
                      onTap: () => navigateToDetail(movie),
                    ),
                  );
                },
              )
            else
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    SizedBox(height: 10),
                    movies.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 40),
                          Text("No movies added yet!",
                              style: TextStyle(color: Colors.white)),
                          SizedBox(height: 40),  // Added extra space here too
                        ],
                      ),
                    )

                        : SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return GestureDetector(
                            onTap: () => navigateToDetail(movie),
                            child: Container(
                              width: 130,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: movie.posterPath != null
                                        ? Image.network(
                                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                      height: 160,
                                      fit: BoxFit.cover,
                                    )
                                        : Container(
                                      height: 160,
                                      width: 120,
                                      color: Colors.grey,
                                      child: Icon(Icons.movie,
                                          size: 40),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    movie.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                    TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageIndex: pageIndex,
      onTap: onNavigationTap,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Movies',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMovieCarousel("Watch Later", "watchLater"),
                      buildMovieCarousel("Favorites", "favorites"),
                      buildMovieCarousel("Watch List", "watchList"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class MovieListDetailScreen extends StatelessWidget {
  final String listName;
  final String title;

  MovieListDetailScreen({required this.listName, required this.title});

  Future<List<Movie>> fetchMovies() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = snapshot.data();
    if (data == null || data[listName] == null) return [];

    final List<dynamic> rawMovies = data[listName];
    return rawMovies
        .map((movie) => Movie(
      id: movie['id'],
      title: movie['title'] ?? '',
      releaseDate: movie['release_date']?.split('-')[0] ?? 'Unknown',
      posterPath: movie['poster_path'],
      voteAverage: movie['vote_average'],
      overview: movie['overview'],
    ))
        .toList();
  }

  void navigateToDetail(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primaryColor,
      ),
      body: FutureBuilder<List<Movie>>(
        future: fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          final movies = snapshot.data ?? [];

          if (movies.isEmpty) {
            return Center(
                child: Text("No movies added yet!",
                    style: TextStyle(color: Colors.white)));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                leading: movie.posterPath != null
                    ? Image.network(
                  'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                  width: 50,
                  fit: BoxFit.cover,
                )
                    : Icon(Icons.movie, size: 40),
                title: Text(
                  movie.title,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  movie.releaseDate,
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () => navigateToDetail(context, movie),
              );
            },
          );
        },
      ),
      backgroundColor: AppColors.secondaryColor,
    );
  }
}
