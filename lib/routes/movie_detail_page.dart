import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moveasy/utils/AppColors.dart';
import 'package:moveasy/utils/movie.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  Future<void> addToList(BuildContext context, String listName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to save movies.')),
      );
      return;
    }

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Create a Map with movie data (similar to SearchPage)
    final movieData = {
      'id': movie.id,
      'title': movie.title,
      'poster_path': movie.posterPath,
      'overview': movie.overview,
      'release_date': movie.releaseDate,
      'vote_average': movie.voteAverage,
      'createdAt': Timestamp.now(),
      'createdBy': user.uid,
    };

    try {
      final snapshot = await docRef.get();
      final data = snapshot.data();

      List<dynamic> currentList = data?[listName] ?? [];

      // Check for duplicate by id
      bool alreadyExists = currentList.any((m) => m['id'] == movie.id);

      if (alreadyExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${movie.title} is already in $listName.')),
        );
        return;
      }

      // Add movie to list
      await docRef.update({
        listName: FieldValue.arrayUnion([movieData])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${movie.title} to $listName.')),
      );
    } catch (e) {
      // Handle if document doesn't exist or update fails
      if (e.toString().contains('NOT_FOUND') || e.toString().contains('not-found')) {
        await docRef.set({
          listName: [movieData]
        }, SetOptions(merge: true));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added ${movie.title} to $listName.')),
        );
      } else {
        print('Error saving movie to $listName: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save movie')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final posterUrl = movie.posterPath != null
        ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
        : null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
              SizedBox(height: kToolbarHeight + 16),
              if (posterUrl != null)
                Center(
                  child: Image.network(
                    posterUrl,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                movie.title,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.titleColor),
              ),
              const SizedBox(height: 10),
              Text(
                "Release Year: ${movie.releaseDate != null ? movie.releaseDate!.split('-')[0] : 'Unknown'}",
                style: const TextStyle(fontSize: 20, color: AppColors.textColor),
              ),
              const SizedBox(height: 10),
              Text(
                "IMDb Rating: ${movie.voteAverage?.toStringAsFixed(1) ?? 'N/A'} / 10",
                style: const TextStyle(fontSize: 18, color: Colors.amber),
              ),
              const SizedBox(height: 30),
              Text(
                movie.overview?.isNotEmpty == true ? movie.overview! : "No overview available.",
                style: const TextStyle(fontSize: 16, color: AppColors.textColor),
              ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => addToList(context, 'favorites'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonColor),
                      child: const Text('Add to Favorites', style: TextStyle(color: AppColors.buttonTextColor)),
                    ),
                    ElevatedButton(
                      onPressed: () => addToList(context, 'watchList'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonColor),
                      child: const Text('Add to Watched', style: TextStyle(color: AppColors.buttonTextColor)),
                    ),
                    ElevatedButton(
                      onPressed: () => addToList(context, 'watchLater'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonColor),
                      child: const Text('Add to Watch Later', style: TextStyle(color: AppColors.buttonTextColor)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
