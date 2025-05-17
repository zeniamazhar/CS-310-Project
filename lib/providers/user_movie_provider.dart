import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moveasy/utils/movie.dart';
import 'dart:async';

final userMovieListProvider =
StateNotifierProvider<UserMovieListNotifier, AsyncValue<Map<String, List<Movie>>>>(
      (ref) => UserMovieListNotifier(),
);
class UserMovieListNotifier extends StateNotifier<AsyncValue<Map<String, List<Movie>>>> {
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;


  UserMovieListNotifier() : super(const AsyncValue.loading()) {
    _listenToUserMovies();
  }

  void _listenToUserMovies() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = const AsyncValue.data({});
      return;
    }

    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        state = const AsyncValue.data({});
        return;
      }

      final lists = ['watchLater', 'favorites', 'watchList'];
      final Map<String, List<Movie>> result = {};

      for (final listName in lists) {
        final List<dynamic> rawMovies = data[listName] ?? [];
        result[listName] = rawMovies
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

      state = AsyncValue.data(result);
    }, onError: (e, st) {
      state = AsyncValue.error(e, st);
    });
  }

  Future<void> deleteMovie(String listName, int movieId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snapshot = await userRef.get();
      final data = snapshot.data();

      if (data == null || data[listName] == null) return;

      List<dynamic> movies = List.from(data[listName]);
      movies.removeWhere((movie) => movie['id'] == movieId);

      await userRef.update({listName: movies});
      // No need to call fetchAllLists() because snapshot listener updates state automatically
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
