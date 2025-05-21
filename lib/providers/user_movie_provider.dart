import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moveasy/utils/movie.dart';
import 'dart:async';

/// CHANGED: provider is now auto-dispose so stale state is dropped
final userMovieListProvider = // CHANGED
StateNotifierProvider.autoDispose<UserMovieListNotifier,
    AsyncValue<Map<String, List<Movie>>>>( // CHANGED
      (ref) => UserMovieListNotifier(),
);

class UserMovieListNotifier
    extends StateNotifier<AsyncValue<Map<String, List<Movie>>>> {
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;
  StreamSubscription<User?>? _authSubscription;          // NEW

  UserMovieListNotifier() : super(const AsyncValue.loading()) {
    _authSubscription = FirebaseAuth.instance              // NEW
        .authStateChanges()
        .listen((_) => _restart());                        // NEW
    _restart();                                           // CHANGED (initial load routed here)
  }

  /// NEW: (re)attach a Firestore listener for **whoever is currently logged in**
  void _restart() {                                       // NEW
    _subscription?.cancel();                              // CHANGED
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = const AsyncValue.data({});
      return;
    }

    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen(_handleSnapshot, onError: _handleError);   // CHANGED
  }

  /// NEW: pulled snapshot logic into its own method (body unchanged)
  void _handleSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {   // NEW
    final data = snapshot.data();
    if (data == null) {
      state = const AsyncValue.data({});
      return;
    }

    final lists = ['watchLater', 'favorites', 'watchList'];
    final Map<String, List<Movie>> result = {};

    for (final listName in lists) {
      final List<dynamic> rawMovies = data[listName] ?? [];

      // Map and parse movies including createdAt as DateTime
      final movies = rawMovies.map((movie) => Movie(
        id: movie['id'],
        title: movie['title'] ?? '',
        releaseDate: movie['release_date']?.split('-')[0] ?? 'Unknown',
        posterPath: movie['poster_path'],
        voteAverage: movie['vote_average']?.toDouble(),
        overview: movie['overview'],
        createdAt:
        (movie['createdAt'] as Timestamp?)?.toDate(),               // unchanged
        createdBy: movie['createdBy'] as String?,
      )).toList();

      // Sort movies by createdAt descending (most recent first)
      movies.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      result[listName] = movies;
    }

    state = AsyncValue.data(result);
  }

  /// NEW: small wrapper for onError so restart logic stays clean
  void _handleError(Object e, StackTrace st) {            // NEW
    state = AsyncValue.error(e, st);
  }

  // --------------- existing public API (unchanged except FIX) -----------------
  Future<void> deleteMovie(String listName, int movieId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        state = AsyncValue.error('User not logged in', StackTrace.current); // FIX
        return;
      }

      final userRef =
      FirebaseFirestore.instance.collection('users').doc(user.uid);
      final doc = await userRef.get();
      final data = doc.data() ?? {};

      List<dynamic> movies = List.from(data[listName]);
      movies.removeWhere((movie) => movie['id'] == movieId);

      await userRef.update({listName: movies});
      // snapshot listener updates state automatically
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  // -----------------------------------------------------------------

  @override
  void dispose() {                                       // CHANGED
    _subscription?.cancel();
    _authSubscription?.cancel();                         // NEW
    super.dispose();
  }
}
