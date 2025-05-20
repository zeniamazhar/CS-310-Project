import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moveasy/utils/AppColors.dart';
import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moveasy/utils/movie.dart';
import 'package:moveasy/routes/movie_detail_page.dart';

const String imageBaseUrl = 'https://image.tmdb.org/t/p/w200';
const String apiKey = 'ca5edc9a327bd63a0f73c8a053537c37';
const String searchBaseUrl = 'https://api.themoviedb.org/3/search/movie';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

Future<List<Map<String, dynamic>>> searchMovies(String query) async {
  final response = await http.get(Uri.parse(
    '$searchBaseUrl?api_key=$apiKey&query=${Uri.encodeQueryComponent(query)}',
  ));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(jsonData['results']);
  } else {
    throw Exception('Failed to load movies');
  }
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> searchResults = [];
  String searchQuery = '';
  Timer? _debounce;

  void _onSearchChanged(String query) {
    setState(() => searchQuery = query);

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (query.isNotEmpty) {
        final results = await searchMovies(query);
        setState(() => searchResults = results);
      } else {
        setState(() => searchResults = []);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Widget buildMovieCard(Map<String, dynamic> movie) {
    return GestureDetector(
      onTap: () {
        final movieObj = Movie(
          id: movie['id'],
          title: movie['title'] ?? '',
          posterPath: movie['poster_path'],
          overview: movie['overview'],
          releaseDate: movie['release_date'],
          voteAverage: (movie['vote_average'] is int)
              ? (movie['vote_average'] as int).toDouble()
              : movie['vote_average'] ?? 0.0,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movieObj),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Image.network(
              '$imageBaseUrl${movie['poster_path']}',
              width: 100,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 100,
                height: 150,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie['title'] ?? 'No Title',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor,
                      ),
                    ),
                    Text(
                      movie['release_date'] != null
                          ? movie['release_date'].split('-')[0]
                          : 'Unknown Year',
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      movie['overview'] != null
                          ? movie['overview'].substring(0, min(80, movie['overview'].length)) + '...'
                          : 'No description.',
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          "IMDb: ${movie['vote_average'] ?? 'N/A'} / 10",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          final user = FirebaseAuth.instance.currentUser;

                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('You must be logged in to save movies.')),
                            );
                            return;
                          }

                          final movieData = {
                            'id': movie['id'],
                            'title': movie['title'],
                            'poster_path': movie['poster_path'],
                            'overview': movie['overview'],
                            'release_date': movie['release_date'],
                            'vote_average': movie['vote_average'],
                            'createdAt': Timestamp.now(),
                            'createdBy': user.uid,
                          };

                          final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

                          try {
                            await userDoc.update({
                              'watchLater': FieldValue.arrayUnion([movieData])
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${movie['title']} added to Watch Later')),
                            );
                          } catch (e) {
                            if (e.toString().contains('NOT_FOUND')) {
                              await userDoc.set({
                                'watchLater': [movieData]
                              }, SetOptions(merge: true));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${movie['title']} added to Watch Later')),
                              );
                            } else {
                              print('Error saving movie: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to save movie')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                        ),
                        child: const Text("Add to Watch Later"),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: TextField(
          autofocus: true,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.grey[300]),
            border: InputBorder.none,
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ),
      ),
      body: searchResults.isEmpty
          ? const Center(
        child: Text(
          "No movies found",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (_, index) => buildMovieCard(searchResults[index]),
      ),
    );
  }
}
