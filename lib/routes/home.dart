import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveasy/utils/AppColors.dart';
import 'package:moveasy/utils/app_scaffold.dart';
import 'package:moveasy/utils/movie.dart';
import 'package:moveasy/routes/movie_detail_page.dart';
import 'package:moveasy/providers/movie_provider.dart';

const String imageBaseUrl = 'https://image.tmdb.org/t/p/w200';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  void navigateToDetails(BuildContext context, Map<String, dynamic> movieData) {
    final movie = Movie(
      id: movieData['id'],
      title: movieData['title'] ?? '',
      posterPath: movieData['poster_path'],
      overview: movieData['overview'],
      releaseDate: movieData['release_date'],
      voteAverage: (movieData['vote_average'] is int)
          ? (movieData['vote_average'] as int).toDouble()
          : movieData['vote_average'] ?? 0.0,
        createdAt: movieData['createdAt'],
        createdBy: movieData['createdBy']
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movie: movie),
      ),
    );
  }

  Widget buildMovieRow(BuildContext context, List<Map<String, dynamic>> movies) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final posterPath = movie['poster_path'];

          return GestureDetector(
            onTap: () => navigateToDetails(context, movie),
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

  Widget section(BuildContext context, String title, List<Map<String, dynamic>> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Center(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.titleColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        buildMovieRow(context, movies),
        const SizedBox(height: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieState = ref.watch(movieProvider);

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
        child: movieState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Text(
              "Failed to load movies: $err",
              style: const TextStyle(color: AppColors.textColor),
            ),
          ),
          data: (movies) => ListView(
            padding: const EdgeInsets.only(top: kToolbarHeight + 16, bottom: 20),
            children: [
              section(context, "Trending Movies", movies.trending),
              section(context, "New Releases", movies.nowPlaying),
              section(context, "Upcoming", movies.upcoming),
            ],
          ),
        ),
      ),
    );
  }
}
