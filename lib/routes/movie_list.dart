import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moveasy/utils/AppColors.dart';
import 'package:moveasy/utils/movie.dart';
import 'package:moveasy/utils/app_scaffold.dart';
import 'movie_detail_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveasy/providers/user_movie_provider.dart';

class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
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

    // Refresh UI after deletion
    setState(() {});
  }

  void navigateToDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
    );
  }

  Widget buildMovieCarousel(String title, String listName) {
    final movieListState = ref.watch(userMovieListProvider);

    return movieListState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error loading $title')),
      data: (allLists) {
        final movies = allLists[listName] ?? [];
        final isEditing = isEditingMap[listName] ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Center(
              child: Row(
                children: [
                  const SizedBox(width: 50),
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryButtonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                          style: const TextStyle(
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
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            if (isEditing)
              movies.isEmpty
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text("No movies added yet!",
                      style: TextStyle(color: Colors.white)),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
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
                          : const Icon(Icons.movie, size: 80),
                      title: Text(movie.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(movie.releaseDate,
                          style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),

                          onPressed: () async {
                            await ref.read(userMovieListProvider.notifier).deleteMovie(listName, movie.id);
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
                    const SizedBox(height: 10),
                    movies.isEmpty
                        ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text("No movies added yet!",
                          style: TextStyle(color: Colors.white)),
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
                              margin: const EdgeInsets.symmetric(horizontal: 8),
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
                                      child: const Icon(Icons.movie, size: 40),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    movie.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white),
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
            const SizedBox(height: 20),
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Movies',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
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

class MovieListDetailScreen extends StatefulWidget {
  final String listName;
  final String title;

  MovieListDetailScreen({required this.listName, required this.title});

  @override
  _MovieListDetailScreenState createState() => _MovieListDetailScreenState();
}

class _MovieListDetailScreenState extends State<MovieListDetailScreen> {
  bool _sortNewestFirst = true;
  late Future<List<Movie>> _futureMovies;

  @override
  void initState() {
    super.initState();
    _futureMovies = fetchMovies();
  }

  Future<List<Movie>> fetchMovies() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = snapshot.data();
    if (data == null || data[widget.listName] == null) return [];

    final List<dynamic> rawMovies = data[widget.listName];

    // Sort by createdAt timestamp based on _sortNewestFirst
    rawMovies.sort((a, b) {
      final aTime = (a['createdAt'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = (b['createdAt'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
      return _sortNewestFirst ? bTime.compareTo(aTime) : aTime.compareTo(bTime);
    });

    return rawMovies.map((movie) => Movie(
      id: movie['id'],
      title: movie['title'] ?? '',
      releaseDate: movie['release_date']?.split('-')[0] ?? 'Unknown',
      posterPath: movie['poster_path'],
      voteAverage: movie['vote_average']?.toDouble(),
      overview: movie['overview'],
      createdAt: (movie['createdAt'] as Timestamp?)?.toDate(),
      createdBy: movie['createdBy'] as String?,
    )).toList();
  }

  void _toggleSortOrder() {
    setState(() {
      _sortNewestFirst = !_sortNewestFirst;
      _futureMovies = fetchMovies();  // re-fetch with new sort order
    });
  }

  void navigateToDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(_sortNewestFirst ? Icons.arrow_downward : Icons.arrow_upward),
            tooltip: _sortNewestFirst ? 'Sort: Newest First' : 'Sort: Oldest First',
            onPressed: _toggleSortOrder,
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          final movies = snapshot.data ?? [];

          if (movies.isEmpty) {
            return const Center(
                child: Text("No movies added yet!",
                    style: TextStyle(color: Colors.white)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
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
                    : const Icon(Icons.movie, size: 40),
                title: Text(
                  movie.title,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  movie.releaseDate,
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () => navigateToDetail(movie),
              );
            },
          );
        },
      ),
      backgroundColor: AppColors.secondaryColor,
    );
  }
}

