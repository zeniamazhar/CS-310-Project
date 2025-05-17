import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

const apiKey = 'ca5edc9a327bd63a0f73c8a053537c37';

final movieProvider = AsyncNotifierProvider<MovieNotifier, MovieState>(MovieNotifier.new);

class MovieState {
  final List<Map<String, dynamic>> trending;
  final List<Map<String, dynamic>> nowPlaying;
  final List<Map<String, dynamic>> upcoming;

  MovieState({
    required this.trending,
    required this.nowPlaying,
    required this.upcoming,
  });

  factory MovieState.initial() => MovieState(trending: [], nowPlaying: [], upcoming: []);
}

class MovieNotifier extends AsyncNotifier<MovieState> {
  @override
  Future<MovieState> build() async {
    final trending = await _fetch("trending/movie/week");
    final nowPlaying = await _fetch("movie/now_playing");
    final upcoming = await _fetch("movie/upcoming");

    return MovieState(
      trending: trending,
      nowPlaying: nowPlaying,
      upcoming: upcoming,
    );
  }

  Future<List<Map<String, dynamic>>> _fetch(String category) async {
    final url = 'https://api.themoviedb.org/3/$category?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(jsonData['results']);
    } else {
      return [];
    }
  }
}
