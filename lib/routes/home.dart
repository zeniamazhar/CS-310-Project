import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moveasy/utils/AppColors.dart';
import 'package:moveasy/utils/app_scaffold.dart';
import 'package:moveasy/utils/movie.dart';
import 'package:moveasy/routes/movie_detail_page.dart';

const String imageBaseUrl = 'https://image.tmdb.org/t/p/w200';
const String apiKey = 'ca5edc9a327bd63a0f73c8a053537c37';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> trending = [];
  List<Map<String, dynamic>> nowPlaying = [];
  List<Map<String, dynamic>> upcoming = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    try {
      try {
        final trendingData = await fetchMovies("trending/movie/week");
        final nowPlayingData = await fetchMovies("movie/now_playing");
        final upcomingData = await fetchMovies("movie/upcoming");

        setState(() {
          trending = trendingData;
          nowPlaying = nowPlayingData;
          upcoming = upcomingData;
          isLoading = false;
        });
      } catch (e) {
        print("Error loading TMDB movies: $e");
        setState(() {
          isLoading = false; // <- still stop spinner even if error
        });
      }

    } catch (e) {
      print("Error fetching movies: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> fetchMovies(String category) async {
    final url = 'https://api.themoviedb.org/3/$category?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(jsonData['results']);
    } else {
      throw Exception('Failed to load $category movies');
    }
  }

  void navigateToDetails(Map<String, dynamic> movieData) {
    final movie = Movie(
      id: movieData['id'],
      title: movieData['title'] ?? '',
      posterPath: movieData['poster_path'],
      overview: movieData['overview'],
      releaseDate: movieData['release_date'],
      voteAverage: (movieData['vote_average'] is int)
          ? (movieData['vote_average'] as int).toDouble()
          : movieData['vote_average'] ?? 0.0,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movie: movie),
      ),
    );
  }

  Widget buildMovieRow(List<Map<String, dynamic>> movies) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final posterPath = movie['poster_path'];

          return GestureDetector(
            onTap: () => navigateToDetails(movie),
            child: Container(
              width: 130,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  posterPath != null
                      ? Image.network(
                    '$imageBaseUrl$posterPath',
                    width: 120,
                    height: 170,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 120,
                      height: 170,
                      color: Colors.grey,
                      child: const Icon(Icons.broken_image),
                    ),
                  )
                      : Container(
                    width: 120,
                    height: 170,
                    color: Colors.grey,
                    child: const Icon(Icons.broken_image),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    movie['title'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget section(String title, List<Map<String, dynamic>> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.titleColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        buildMovieRow(movies),
        const SizedBox(height: 30),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageIndex: 0,
      onTap: (index) {
        if (index == 1) {
          Navigator.pushReplacementNamed(context, '/movieList');
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, '/profile');
        }
      },
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: const EdgeInsets.only(top: kToolbarHeight + 16, bottom: 20),
          children: [
            section("Trending Movies", trending),
            section("New Releases", nowPlaying),
            section("Upcoming", upcoming),
          ],
        ),
      ),
    );
  }
}
